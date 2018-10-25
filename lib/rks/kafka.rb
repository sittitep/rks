require 'kafka'
require 'avro_turf'

Kafka.module_eval do
  def self.config
    @config ||= OpenStruct.new
  end

  def self.configure(&block)
    yield config
  end

  def self.client(args = {})
    if args[:new]
      new(config.brokers)
    else
      @client ||= new(config.brokers)
    end
  end

  def self.producer
    @producer ||= client.producer
  end

  def self.consumer
    @consumer ||= client.consumer(group_id: config.consumer_group_id)
  end
end

Kafka::Producer.class_eval do
  alias_method 'original_produce', 'produce'

  def produce(*args)
    payload, topic = JSON.parse(JSON.dump(args[0])), args[1][:topic]

    encoded_value = Application.avro_registry.encode(payload, schema_name: schema_name(topic))
    args[1][:topic] = [Application.config.env, topic].join("-")

    original_produce(encoded_value, **args[1])
  end

  def schema_name(topic)
    Application.camelize(topic)
  end
end
