require 'kafka'

Kafka.module_eval do
  def self.config
    @config ||= OpenStruct.new
  end

  def self.configure(&block)
    yield config
  end

  def self.client
    @client ||= new(config.brokers)
  end

  def self.producer
    @producer ||= client.producer
  end

  def self.consumer
    @consumer ||= client.consumer(group_id: config.consumer_group_id)
  end
end
