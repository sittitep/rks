class Application
  extend ApplicationHelper

  def self.config
    @config ||= OpenStruct.new(
      name: "regular-rks-app", env: "development", 
      logger:  LogStashLogger.new(
        type: :multi_logger,
        outputs: [
          {type: :stdout}
        ]
      )
    )
  end

  def self.current
    @current ||= OpenStruct.new
  end

  def self.configure(&block)
    yield config
  end

  def self.commands
    @commands ||= {}
  end

  def self.events
    @events ||= {}
  end

  def self.logger
    @logger ||= config.logger
  end

  def self.run
    Application.logger.info message: "Application started"

    Application.events.keys.each do |event_name|
      topic = [config.env,event_name].join("-")
      Kafka.consumer.subscribe(topic, start_from_beginning: false)
    end
    # This will loop indefinitely, yielding each message in turn.
    Kafka.consumer.each_message do |message|
      duration = Benchmark.measure {
        initalize_application_current_state(message)
        event_name = message.topic.gsub("#{config.env}-", "")

        Application.logger.info correlation_id: current_correlation_id, status: "started", event: current_event, payload: current_payload
        Application.events[event_name].call
      }
      Application.logger.info correlation_id: current_correlation_id, status: "finished", event: current_event, duration: duration.real.round(3)
    rescue Exception => e
      Application.logger.fatal correlation_id: current_correlation_id, status: "failed", event: current_event, payload: current_payload, error_message: e.message, error_detail: e.backtrace
    end
  end

  def self.initalize_application_current_state(message)
    Application.current.correlation_id = message.key
    Application.current.event = message.topic
    Application.current.payload = JSON.parse(message.value)
  end
end
