module RKS
  module Support
    module Routable
      extend RKS::Support::Concern

      module ClassMethods
        def route(name)
          Router.routes[name].call
        end

        def router
          @router ||= Router
        end
      end

      class Router
        class << self
          def routes
            @routes ||= {}
          end

          def draw
            yield(Router)
          end

          def on(name, to:)
            klass_name, action = to.split('#')
            klass = Object.const_get(klass_name)
            
            routes.merge!({name => Proc.new { klass.new.send(action.to_sym) }})
          end
        end
      end
    end
  end
end
