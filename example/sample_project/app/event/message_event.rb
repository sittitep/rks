class MessageEvent < RKS::Event::Base
  def broadcast
    puts "I'm busy. Forward this to MessageWorker, Correlation Id - #{correlation_id}"
    BroadcastMessageWorker.perform_async(name: payload["name"], message: payload["message"])
  end
end
