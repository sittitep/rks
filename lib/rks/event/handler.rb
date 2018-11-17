module RKS
  module Event
    module Handler
      include RKS::Support::Routable

      class << self
        def call(name)
          route(name)
        end
      end
    end
  end
end
