module RKS
  module Event
    class Base
      include RKS::Event
      # include RKS::Support::Routable::Endpoint

      attr_accessor :correalation_id, :payload

      def initialize(args)
        @correalation_id = args[:correalation_id]
        @payload = args[:payload]
      end
    end
  end
end
