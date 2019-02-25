require 'concurrent'

module RKS
  module Event
    class Processor
      class ProcessorNotInitialized < StandardError; end;
      
      attr_accessor :correlation_id, :event, :payload

      def initialize(correlation_id:, event:, payload:)
        @correlation_id = correlation_id
        @event = event
        @payload = payload

        # self.class.set_current_processor(self)
      end

      def process
        Application.logger.with_rescue_and_duration_event(@correlation_id, @event, @payload) do
          RKS::Event::Handler.call(correlation_id: @correlation_id, event: @event, payload: @payload)
        end
      end

      class << self
        # def set_current_processor(processor)
        #   @current = Concurrent::ThreadLocalVar.new(processor)
        # end

        # def current
        #   if @current
        #     @current.value
        #   else
        #     raise ProcessorNotInitialized, "#set_current_processor is needed"
        #   end
        # end

        def process(args)
          new(args).process
        end
      end
    end
  end
end
