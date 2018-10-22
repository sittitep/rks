require 'kafka'

Kafka.module_eval do
  def self.config
    @config ||= OpenStruct.new
  end

  def self.configure(&block)
    yield config
  end

  def self.client(args)
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
