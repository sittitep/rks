RKS::Controller::Handler.router.draw do |r|
  r.on '/sample-project/hello', to: 'SampleController#hello'
end
