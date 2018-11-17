module RKS
  module Support
    module Routable
      class NoMethodFound < StandardError; end;

      extend RKS::Support::Concern

      module ClassMethods
        def route(name)
          block = router.find(name)
          block.call
        rescue Exception => e
          handle_exception(e)
        end

        def router
          @router ||= Router.new(owner: self.to_s)
        end

        def handle_exception(e)
          if e.class.to_s ==  NoMethodError.to_s
            raise NoMethodFound, "You need to define #{e.name} first"
          else
            raise e
          end
        end
      end

      class Router
        class RouteNotFound < StandardError; end;

        attr_accessor :owner, :routes

        def initialize(owner:)
          @owner = owner
          @routes = {}
        end

        def find(name)
          if route = routes[name]
            route
          else
            raise RouteNotFound, "#{name} is not found in #{owner} routes"
          end
        end

        def draw
          yield(self)
        end

        def on(name, to:)
          klass_name, action = to.split('#')
          klass = Object.const_get(klass_name)
          
          block = Proc.new { klass.new.send(action.to_sym) }
          routes.merge!({name => block})
        end
      end
    end
  end
end
