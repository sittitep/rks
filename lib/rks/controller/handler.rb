module RKS
  module Controller
    module Handler
      include RKS::Support::Routable

      class << self
        def call(correlation_id:, path:, request:)
          route = router.find(path)
          route[:block].call(correlation_id, request)
        end
      end
    end
  end
end
