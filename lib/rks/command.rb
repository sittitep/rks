module RKS
  class Command
    extend ApplicationHelper

    def self.command(args, &block)
      Application.commands[args[:name]] = Proc.new do
        Application.logger.info correlation_id: current_correlation_id, status: "started", command: args[:name], payload: current_payload
        duration = Benchmark.measure {
          yield
        }
        Application.logger.info correlation_id: current_correlation_id, status: "finished", command: args[:name], duration: duration.real.round(3)
        # Application.logger.debug "event:#{args[:produce]} is being produced! | payload: #{result}"
        
        # Kafka.producer.produce(result, topic: args[:produce])
        # Kafka.producer.deliver_messages
      end
    end
  end
end
