require "avro_turf/messaging"

class Application
  extend ApplicationHelper
  include RKS::Support::Configurable

  config_attr name: "regular-rks-app", env: "dev"

  def self.commands
    @commands ||= {}
  end

  def self.events
    @events ||= {}
  end

  def self.logger
    @logger ||= LogStashLogger.new(
      buffer_max_items: 5000,
      buffer_max_interval: 1,
      type: :multi_logger,
      type: :multi_logger,
      outputs: default_logger_outputs
    )
  end

  def self.default_logger_outputs
    outputs = []
    outputs << {type: :stdout}
    outputs << {type: :file, path: "log/#{ENV['RKS_ENV']}.log"} if ENV["LOG_FILE"]
    outputs
  end

  def self.avro_registry
    @avro ||= AvroTurf::Messaging.new(
      schemas_path: "./app/schemas",
      registry_url: Application.config.avro_registry_url
    )
  end

  def self.run
    Application.logger.info message: "Application started"

    Application.events.keys.each do |event_name|
      topic = [config.env,event_name].join("-")
      Kafka.consumer.subscribe(topic)
    end
    # This will loop indefinitely, yielding each message in turn.
    Kafka.consumer.each_message do |message|
      duration = Benchmark.measure {
        initalize_application_current_state(message.key, message.topic, message.value)

        Application.events[current_event].call
      }
      Application.logger.info correlation_id: current_correlation_id, status: "finished", event: current_event, duration: duration.real.round(3)
    rescue Exception => e
      begin
        Application.logger.fatal correlation_id: current_correlation_id, status: "failed", event: current_event, payload: current_payload, error_message: e.message, error_detail: e.backtrace
      rescue Encoding::UndefinedConversionError
        Application.logger.fatal correlation_id: current_correlation_id, status: "failed", event: current_event, error_message: e.message, error_detail: e.backtrace
      end
    end
  end

  def self.convert_event_name(topic)
    topic.gsub("#{config.env}-", "")
  end

  def self.initalize_application_current_state(key, topic, value)
    Application.current.correlation_id = key
    Application.current.event = convert_event_name(topic)
    Application.current.payload = value
  end
end
