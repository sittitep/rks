class MessagesController < RKS::Controller::Base
  PRODUCER = Kafka.client.async_producer(delivery_threshold: 1, delivery_interval: 1, required_acks: 1)

  def send_message
    name, message = request.params['name'], request.params['message']

    payload = {name: name, message: message}
    PRODUCER.produce(payload, topic: "message-received", key: Time.now.to_i, encoding: false)

    ['200', {'Content-Type' => 'text/plain'}, ["OK"]]
  end
end
