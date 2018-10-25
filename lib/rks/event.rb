module RKS
  class Event
    extend ApplicationHelper

    def self.event(args, &block)
      args[:decoding] ||= true
      Application.events[args[:name]] = Proc.new do
        if args[:decoding] 
          decode_message_value(current_topic, current_payload)
        else
          yield(JSON.parse(current_payload))
        end
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
