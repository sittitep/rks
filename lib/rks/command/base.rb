module RKS
  module Command
    class Base
      include RKS::Command
      include RKS::Support::Configurable
      
      attr_accessor :correalation_id, :args

      def initialize(_args)
        @correalation_id = _args[:correalation_id]
        @args = _args[:args]
      end
    end
  end
end
