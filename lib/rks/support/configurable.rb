module RKS
  module Support
    module Configurable
      class InvalidConfugurationName < StandardError; end;

      module ClassMethods
        def config
          @config ||= OpenStruct.new
        end

        def config_attr(*args)
          args.each do |arg|
            @key = case arg.class.to_s
            when "Hash"
              @value = arg.first[1]
              arg.first[0]
            when "Symbol"
              arg
            else
              raise InvalidConfugurationName, "#{args.class.to_s} is not allowed to be a configuration name"
            end.to_s

            config.send("#{@key}=", @value)
          end
        end

        def configure
          yield config
        end
      end
      
      # module InstanceMethods
        
      # end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        # receiver.send :include, InstanceMethods
      end
    end
  end
end
