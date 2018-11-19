module RKS
  module Event
    class Base
      include RKS::Event
      # include RKS::Support::Routable::Endpoint

      attr_accessor :correlation_id, :payload

      def initialize(args)
        @correlation_id = args[:correlation_id]
        @payload = args[:payload]
      end
    end
  end
end
