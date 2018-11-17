module RKS
  module Event
    class Handler
      include RKS::Support::Routable

      class << self
        def call(name)
          Application.logger.with_rescue do
            Application.logger.with_duration do
              route(name)
            end
          end
        end
      end
    end
  end
end
