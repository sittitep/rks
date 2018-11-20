require 'sidekiq'

Sidekiq.configure_server do |config|
  config.logger = nil
end
