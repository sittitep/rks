class MessagesController < RKS::Controller::Base
  def send_message
    name, message = request.params['name'], request.params['message'] 
    ['200', {'Content-Type' => 'text/plain'}, ["#{name}, #{message}"]]
  end
end
