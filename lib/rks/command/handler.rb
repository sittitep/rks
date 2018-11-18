module RKS
  module Command
    module Handler
      class << self
        def call(correalation_id:, klass:, action:, args: nil)
          Application.logger.with_rescue_and_duration_action(correalation_id, "#{klass}##{action}", args) do
            instance = klass.new(correalation_id: correalation_id, args: args)
            instance.send(action)
          end
        end
      end
    end
  end
end
