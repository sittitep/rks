require 'concurrent'

module RKS
  module Controller
    class Processor
      class ProcessorNotInitialized < StandardError; end;
      
      attr_accessor :correlation_id, :path, :request

      def initialize(correlation_id:, path:, request:)
        @correlation_id = correlation_id
        @path = path
        @request = request

        # self.class.set_current_processor(self)
      end

      def process
        Application.logger.with_rescue_and_duration_controller(@correlation_id, @path, @request) do
          RKS::Controller::Handler.call(correlation_id: @correlation_id, path: @path, request: @request)
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
          new(**args).process
        end
      end
    end
  end
end
