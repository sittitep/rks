Application.configure do |config|
  config.name = "sample-project"
  # config.env = ENV.fetch("RKS_ENV", "development")

  # config.redis_host = ENV.fetch("REDIS_HOST", "redis://localhost:6379/1")
  # config.kafka_host = ENV.fetch("KAFKA_HOST", "localhost:9092").split(",")
  # config.avro_registry_url = ENV.fetch("AVRO_REGISTRY_URL", "http://localhost:8081")
  # config.proxy_address = ENV.fetch("PROXY_ADDRESS", nil)
  # config.proxy_port = ENV.fetch("PROXY_PORT", nil)

  # config.server_port = ENV.fetch("SERVER_PORT", 3002)
  # config.server_threads = ENV.fetch("SERVER_THREADS", "1:1")
end

# Application.logger.outputs << RKS::Logger.build_logger({type: :kafka, hosts: Application.config.kafka_host, path: "#{Application.config.env}-#{Application.config.name}-logs", formatter: :json, sync: true})
# Application.logger.outputs << RKS::Logger.build_logger({type: :file, path: "log/#{ENV['RKS_ENV']}.log"})

# Kafka.configure do |config|
#   config.brokers = Application.config.kafka_host
#   config.consumer_group_id = [Application.config.env, Application.config.name].join("-")
# end

# Sidekiq.configure_server do |config|
#   config.redis = { url: Application.config.redis_host }
# end

# Sidekiq.configure_client do |config|
#   config.redis = { url: Application.config.redis_host }
# end
