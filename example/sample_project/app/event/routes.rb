RKS::Event::Handler.router.draw do |r|
  r.on 'message-received', to: 'MessageEvent#broadcast'
end
