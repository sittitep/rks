require 'sidekiq'
require 'sidekiq/processor'

Sidekiq::Processor.class_eval do
  # alias_method :original_execute_job, :execute_job
  def execute_job(worker, cloned_args)
    correlation_id = cloned_args[0]["correlation_id"]
    Application.logger.with_rescue_and_duration_worker(correlation_id, worker.class.name, cloned_args[0], worker.jid) do
      worker.perform(*cloned_args)
    end
  end
end

Sidekiq.configure_server do |config|
  config.logger = nil
end
