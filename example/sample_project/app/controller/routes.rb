RKS::Controller::Handler.router.draw do |r|
  r.on '/sample-project/messages/send', to: 'MessagesController#send_message'
end
