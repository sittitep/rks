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
        Kafka.consumer.subscribe(topic)
      end
      # This will loop indefinitely, yielding each message in turn.
    begin
      Kafka.consumer.each_message(min_bytes: 1) do |message|
        RKS::Event::Processor.process(correlation_id: message.key, event: sanitized_event_name(message.topic), payload: message.value)
      end
    rescue Exception => e
      Application.logger.fatal error_name: e.class.to_s, error_message: e.message, error_detail: e.backtrace
    end
    ensure
      Application.logger.info message: "Application is shutting down gracefully"
      Kafka.consumer.stop
      exit(0)
    end
  
    def sanitized_event_name(topic)
      topic.gsub("#{config.env}-", "")
    end
  end

  module Server
    class << self
      def namespace
        Application.config.name || Application.config.server_namespace
      end

      def app
        @namespace = self.namespace
        Rack::Builder.app do
          map "/#{@namespace}" do
            run Proc.new { |env|
              request = Rack::Request.new(env)
              RKS::Controller::Processor.process(correlation_id: (request.env["HTTP_CORRELATION_ID"] || SecureRandom.hex), path: request.path, request: request)
            }
          end
        end
      end

      def run
        Rack::Handler::Puma.run(Server.app, {
          Port: Application.config.server_port || 3000,
          Threads: Application.config.server_threads || "32:32"
        })
      end
    end
  end
end
