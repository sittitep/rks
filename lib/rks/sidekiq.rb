require 'sidekiq'

module Sidekiq
  module LogStash
    def perform(*args)
      correlation_id = args[0]["correlation_id"]
      content = args[0]["content"]
      begin
        duration = Benchmark.measure {
          Application.logger.info correlation_id: correlation_id, status: "started", worker: self.class.name, jid: self.jid, content: content
          super(*args)
        }
        Application.logger.info correlation_id: correlation_id, status: "finished", worker: self.class.name, jid: self.jid, duration: duration.real.round(3)
      rescue Exception => e
        Application.logger.fatal correlation_id: correlation_id, status: "failed", worker: self.class.name, jid: self.jid, content: content, error_message: e.message, error_detail: e.backtrace
      end
    end
  end
end

Sidekiq.configure_server do |config|
  config.logger = nil
end
