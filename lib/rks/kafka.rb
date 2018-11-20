require 'kafka'

Kafka.module_eval do
  include RKS::Support::Configurable

  class << self
    def client(args = {})
      if args[:new]
        new(config.brokers)
      else
        @client ||= new(config.brokers)
      end
    end

    def producer
      @producer ||= client.producer
    end

    def consumer
      @consumer ||= client.consumer(group_id: config.consumer_group_id)
    end
  end
end

Kafka::Producer.class_eval do
  alias_method 'original_produce', 'produce'

  def produce(*args)
    encoding = args[1][:encoding] == true || args[1][:encoding] == nil
    payload, topic, encoding = JSON.parse(JSON.dump(args[0])), args[1][:topic]
    args[1][:topic] = [Application.config.env, topic].join("-")
    args[1].delete(:encoding)

    payload = if encoding
      Application.avro_registry.encode(payload, schema_name: camelize(topic))
    else
      JSON.dump(payload)
    end

    original_produce(payload, **args[1])
  end

  def camelize(str)
    str.split('-').collect(&:capitalize).join
  end
end
