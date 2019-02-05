class SampleController < RKS::Controller::Base
  def hello
    name = request.params['name']
    ['200', {'Content-Type' => 'text/plain'}, ["OK, #{name}"]]
  end
end
