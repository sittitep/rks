require 'kafka'

Kafka.module_eval do
  include RKS::Support::Configurable

  class << self
    def client_pool
      @client_pool ||= ConnectionPool.new(size: (config.client_pool || 25), timeout: 15) {
        new(config.brokers)
      }
    end

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

Kafka::Consumer.class_eval do
private
  def fetch_batches
    # Return early if the consumer has been stopped.
    return [] if !@running

    join_group unless @group.member?

    trigger_heartbeat

    resume_paused_partitions!

    if !@fetcher.data?
      @logger.debug "No batches to process"
      []
    else
      tag, message = @fetcher.poll

      case tag
      when :batches
        # make sure any old batches, fetched prior to the completion of a consumer group sync,
        # are only processed if the batches are from brokers for which this broker is still responsible.
        message.select { |batch| @group.assigned_to?(batch.topic, batch.partition) }
      when :exception
        raise message
      end
    end
  rescue OffsetOutOfRange => e
    @logger.error "Invalid offset #{e.offset} for #{e.topic}/#{e.partition}, resetting to default offset"

    @offset_manager.seek_to_default(e.topic, e.partition)

    retry
  rescue ConnectionError => e
    @logger.error "Connection error while fetching messages: #{e}"

    raise FetchError, e
  end
end
