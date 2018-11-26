module RKS
  module Event
    module Handler
      include RKS::Support::Routable

      class << self
        def call(correlation_id:, event:, payload:)
          route = router.find(event)
          decoded_payload = decode(payload: payload, options: route[:options])
          route[:block].call(correlation_id, decoded_payload)
        end

        def decode(payload:, options: {})
          if options[:type] == "AVRO"
            Application.avro_registry.decode(payload, schema_name: options[:avro][:schema_name], namespace: options[:avro][:namespace])
          else
            JSON.parse(payload)
          end
        end
      end
    end
  end
end
