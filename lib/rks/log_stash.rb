require 'logstash-logger'

LogStashLogger.configure do |config|
  config.customize_event do |event|
    event["app"] = Application.config.name
    event["env"] = Application.config.env
  end
end
