module RKS
  module Support
    module Routable
      class NoMethodFound < StandardError; end;

      extend RKS::Support::Concern

      module ClassMethods
        def router
          @router ||= Router.new(owner: self.to_s)
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

        def on(name, to:, options: {})
          klass_name, action = to.split('#')
          unless Object.const_defined?(klass_name)
            load_routable(Kernel.caller, klass_name)
          end

          klass = Object.const_get(klass_name)
          block = Proc.new { |correlation_id, payload| klass.new(correlation_id: correlation_id, payload: payload).send(action.to_sym) }
          routes.merge!({name => {block: block, options: options}})
        end

      private
        def load_routable(paths, klass_name)
          path = paths.find{|l| l.include?("`block in <top (required)>'")}.split[0].split("/")[1...-1]
          Dir[File.join("/", *path ,"*.rb")].each do |file|
            filename = File.basename(file, ".rb")
            if filename.split("_").map(&:capitalize).join == klass_name 
              require file
            end
          end
        end
      end
    end
  end
end
