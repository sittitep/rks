require "avro_turf/messaging"
require 'rack'
require 'rack/handler/puma'

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
        Kafka.consumer.subscribe(topic, max_bytes_per_partition: 1)
      end
      # This will loop indefinitely, yielding each message in turn.
      Kafka.consumer.each_message(min_bytes: 1) do |message|
        RKS::Event::Processor.process(correlation_id: message.key, event: sanitized_event_name(message.topic), payload: message.value)
      end
    end
  
    def sanitized_event_name(topic)
      topic.gsub("#{config.env}-", "")
    end
  end

  module Server
    class << self
      def app
        Proc.new do |env|
          request = Rack::Request.new(env)
          RKS::Controller::Processor.process(correlation_id: SecureRandom.hex, path: request.path, request: request)
        end
      end

      def run
        Rack::Handler::Puma.run(Server.app)
      end
    end
  end
end
