module RKS
  module Support
    module Configurable
      extend RKS::Support::Concern

      class InvalidConfugurationName < StandardError; end;

      module ClassMethods
        def config
          @config ||= OpenStruct.new
        end

        def config_attr(configs)
          if configs.class.to_s == "Hash"
            configs.each { |k,v| config.send("#{k.to_s}=", v) }
          else
            raise InvalidConfugurationName, "#{configs.class.to_s} is not allowed to be a configuration"
          end
        end

        def configure
          yield config
        end
      end
    end
  end
end
