module RKS
  module Command
    class Base
      include RKS::Command
      include RKS::Support::Configurable
      
      attr_accessor :correlation_id, :args

      def initialize(_args)
        @correlation_id = _args[:correlation_id]
        @args = _args[:args]
      end
    end
  end
end
