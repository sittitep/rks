#         Application.current.payload = if args[:decoding] == true || args[:decoding] == nil
#           decode_message_value(current_event, current_payload)
#         else
#           JSON.parse(current_payload)
#         end

#         Application.logger.info correlation_id: current_correlation_id, status: "started", event: current_event, payload: current_payload
#         yield(current_payload)
RKS::Logger = LogStashLogger
RKS::Logger.module_eval do
  class << self
    def init(args = {})
          new_args = {
        buffer_max_items: 5000,
        buffer_max_interval: 1,
        type: :multi_logger,
        outputs: [
          {type: :stdout}
          # {type: :file, path: "log/#{ENV['RKS_ENV']}.log"} if ENV["LOG_FILE"]
        ]
      }.merge!(args)
      new(new_args)
    end
  end
end

RKS::Logger.configure do |config|
  config.customize_event do |event|
    event["app"] = Application.config.name
    event["env"] = Application.config.env
  end
end

LogStashLogger::MultiLogger.class_eval do
  def with_rescue_and_duration_event
    info correlation_id: RKS::Event::Processor.current.key, status: "started", event: RKS::Event::Processor.current.event, payload: RKS::Event::Processor.current.payload
    duration = Benchmark.measure { @result = yield }
    info correlation_id: RKS::Event::Processor.current.key, status: "finished", event: RKS::Event::Processor.current.event, duration: duration.real.round(3)

    @result
  rescue Exception => e
    Application.logger.fatal correlation_id: RKS::Event::Processor.current.key, status: "failed", event: RKS::Event::Processor.current.event, error_name: e.class.to_s, error_message: e.message, error_detail: e.backtrace
    nil
  end

  def with_rescue_and_duration_action(correalation_id, actor, args)
    info correlation_id: correalation_id, status: "started", action: actor, args: args
    duration = Benchmark.measure { @result = yield }
    info correlation_id: correalation_id, status: "finished", action: actor, duration: duration.real.round(3)

    @result
  rescue Exception => e
    Application.logger.fatal correlation_id: correalation_id, status: "failed", action: actor, error_name: e.class.to_s, error_message: e.message, error_detail: e.backtrace
    nil
  end
end
