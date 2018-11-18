module RKS
  module Event
    class Base
      include RKS::Event
      include RKS::Support::Routable::Endpoint
    end
  end
end
