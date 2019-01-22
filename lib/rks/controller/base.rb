module RKS
  module Controller
    class Base
      attr_accessor :correlation_id, :request

      def initialize(args)
        @correlation_id = args[:correlation_id]
        @request = args[:request]
      end
    end
  end
end
