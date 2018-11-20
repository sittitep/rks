require 'sidekiq/processor'

Sidekiq::Processor.class_eval do
  def execute_job(worker, cloned_args)
    correlation_id = cloned_args[0]["correlation_id"]
    Application.logger.with_rescue_and_duration_worker(correlation_id, worker.class.name, cloned_args[0], worker.jid) do
      worker.perform(*cloned_args)
    end
  end
end
