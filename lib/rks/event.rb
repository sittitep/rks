module RKS
  class Event
    extend ApplicationHelper

    def self.event(args, &block)
      Application.events[args[:name]] = Proc.new do
        Application.current.payload = if args[:decoding] == true || args[:decoding] == nil
          decode_message_value(current_event, current_payload)
        else
          JSON.parse(current_payload)
        end

        Application.logger.info correlation_id: current_correlation_id, status: "started", event: current_event, payload: current_payload
        yield(current_payload)
      end
    end

    def self.decode_message_value(topic, value)
      Application.avro_registry.decode(value, schema_name: camelize(topic))
    end

    def self.camelize(str)
      str.split('-').collect(&:capitalize).join
    end
  end
end
