require "avro_turf/messaging"

class Application
  include RKS::Support::Configurable

  config_attr name: "regular-rks-app", env: "dev"

  class << self
    def logger
      @logger ||= RKS::Logger.init
    end
  
    def avro_registry
      @avro ||= AvroTurf::Messaging.new(
        schemas_path: "./app/schemas",
        registry_url: Application.config.avro_registry_url
      )
    end
  
    def run
      Application.logger.info message: "Application started"
  
      RKS::Event::Handler.router.routes.keys.each do |event_name|
        topic = [config.env,event_name].join("-")
        Kafka.consumer.subscribe(topic)
      end
      # This will loop indefinitely, yielding each message in turn.
      options = {max_bytes_per_partition: 2 * 1024 * 1024, max_wait_time: 1}
      Kafka.consumer.each_message(options) do |message|
        RKS::Event::Processor.process(correlation_id: message.key, event: sanitized_event_name(message.topic), payload: message.value)
      end
    end
  
    def sanitized_event_name(topic)
      topic.gsub("#{config.env}-", "")
    end
  end
end
