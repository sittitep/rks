class MessagesController < RKS::Controller::Base
  PRODUCER = Kafka.client.async_producer(delivery_threshold: 1, delivery_interval: 1, required_acks: 1)

  def send_message
    name, message = request.params['name'], request.params['message']

    puts "=" * 10
    puts "Createing an event for a message, #{message}, by #{name}"
    puts "=" * 10
    
    payload = {name: name, message: message}
    PRODUCER.produce(payload, topic: "message-received", key: correlation_id, encoding: false)

    ['200', {'Content-Type' => 'text/plain'}, ["OK"]]
  end
end
