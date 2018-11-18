module RKS
  module Event
    module Handler
      include RKS::Support::Routable

      class << self
        def call(key:, event:, payload:)
          route = router.find(event)
          route[:block].call(payload)
        end
      end
    end
  end
end
