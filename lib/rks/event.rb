module RKS
  class Event
    extend ApplicationHelper

    def self.event(args, &block)
      Application.events[args[:name]] = Proc.new do
        yield(current_payload)
      end
    end
  end
end
