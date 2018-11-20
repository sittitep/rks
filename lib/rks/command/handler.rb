module RKS
  module Command
    module Handler
      class << self
        def call(correlation_id:, klass:, action:, args: nil)
          Application.logger.with_rescue_and_duration_command(correlation_id, "#{klass}##{action}", args) do
            instance = klass.new(correlation_id: correlation_id, args: args)
            instance.send(action)
          end
        end
      end
    end
  end
end
