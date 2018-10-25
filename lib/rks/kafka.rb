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
    payload, topic, encoding = JSON.parse(JSON.dump(args[0])), args[1][:topic], args[1][:encoding] == true
    args[1][:topic] = [Application.config.env, topic].join("-")
    args[1].delete(:encoding)

    if encoding
      payload = Application.avro_registry.encode(payload, schema_name: camelize(topic))
    end

    original_produce(payload, **args[1])
  end

  def camelize(str)
    str.split('-').collect(&:capitalize).join
  end
end
