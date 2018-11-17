module RKS
  module Support
    module Routable
      extend RKS::Support::Concern

      module ClassMethods
        def route(name)
          route = Router.find(name)
          route.call
        end

        def router
          @router ||= Router
        end
      end

      class Router
        class RouteNotFound < StandardError; end;

        class << self
          def find(name)
            if route = routes[name]
              route
            else
              raise RouteNotFound, "#{name} is not found"
            end
          end

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
