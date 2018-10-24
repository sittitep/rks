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
  def produce(*args)
    encoded_value = Application.avro_registry.encode(args[0], schema_name: args[1])
    args[0] = encoded_value
    args[1] = [Application.config.env, args[1]].join("-")

    super(args)
  end
end
