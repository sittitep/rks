module RKS
  module Event
    class Processor
      class ProcessorNotInitialized < StandardError; end;
      
      attr_accessor :key, :event, :payload

      def initialize(key:, event:, payload:)
        @key = key
        @event = event
        @payload = payload

        self.class.set_current_processor(self)
      end

      def process
        Application.logger.with_rescue_and_duration do
          RKS::Event::Handler.call(@event)
        end
      end

      class << self
        def set_current_processor(processor)
          @current = Concurrent::ThreadLocalVar.new(processor)
        end

        def current
          if @current
            @current.value
          else
            raise ProcessorNotInitialized, "#set_current_processor is needed"
          end
        end

        def process(args)
          new(args).process
        end
      end
    end
  end
end

