require 'logstash-logger'

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
  def with_rescue_and_duration_event(correlation_id, event, payload)
    begin
      info correlation_id: correlation_id, status: "started", event: event, payload: payload
    rescue Encoding::UndefinedConversionError
      info correlation_id: correlation_id, status: "started", event: event
    end
    
    duration = Benchmark.measure { @result = yield }
    info correlation_id: correlation_id, status: "finished", event: event, duration: duration.real.round(3)

    @result
  rescue Exception => e
    Application.logger.fatal correlation_id: correlation_id, status: "failed", event: event, error_name: e.class.to_s, error_message: e.message, error_detail: e.backtrace
    nil
  end

  def with_rescue_and_duration_controller(correlation_id, path, request)
    info correlation_id: correlation_id, status: "started", path: path, params: request.params
    duration = Benchmark.measure { @result = yield }
    info correlation_id: correlation_id, status: "finished", path: path, duration: duration.real.round(3)

    @result
  rescue Exception => e
    Application.logger.fatal correlation_id: correlation_id, status: "failed", path: path, error_name: e.class.to_s, error_message: e.message, error_detail: e.backtrace
    
    response = JSON.dump({error_name: e.class.to_s, error_message: e.message, error_detail: e.backtrace})
    ['500', {'Content-Type' => 'text/json'}, [response]]
  end

  def with_rescue_and_duration_command(correlation_id, actor, args)
    info correlation_id: correlation_id, status: "started", command: actor, args: args
    duration = Benchmark.measure { @result = yield }
    info correlation_id: correlation_id, status: "finished", command: actor, duration: duration.real.round(3)

    @result
  rescue Exception => e
    Application.logger.fatal correlation_id: correlation_id, status: "failed", command: actor, error_name: e.class.to_s, error_message: e.message, error_detail: e.backtrace
    nil
  end

  def with_rescue_and_duration_worker(correlation_id, worker, args, jid)
    info correlation_id: correlation_id, status: "started", worker: worker, jid: jid, args: args
    duration = Benchmark.measure { @result = yield }
    info correlation_id: correlation_id, status: "finished", worker: worker, jid: jid, duration: duration.real.round(3)

    @result
  rescue Exception => e
    Application.logger.fatal correlation_id: correlation_id, status: "failed", worker: worker, jid: jid, error_name: e.class.to_s, error_message: e.message, error_detail: e.backtrace
    raise e
  end
end
