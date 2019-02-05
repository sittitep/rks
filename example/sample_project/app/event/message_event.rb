class MessageEvent < RKS::Event::Base
  def broadcast
    puts "=" * 10
    puts "I'm busy. Forward this to MessageWorker, Correlation Id - #{correlation_id}"
    puts "=" * 10
    BroadcastMessageWorker.perform_async(name: payload["name"], message: payload["message"])
  end
end
