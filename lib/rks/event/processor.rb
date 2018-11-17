module RKS
  module Event
    class Processor
      attr_accessor :key, :event, :payload
      
      def initialize(key:, event:, payload:)
        @key = key
        @event = event
        @payload = payload

        self.class.set_current_processor(self)
      end

      def process
        RKS::Event::Handler.call(@event)
      end

      class << self
        def set_current_processor(processor)
          @current = Concurrent::ThreadLocalVar.new(processor)
        end

        def current
          @current.value
        end

        def process(args)
          new(args).process
        end
      end
    end
  end
end
