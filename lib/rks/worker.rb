module RKS
  class Worker
    include Sidekiq::Worker
    sidekiq_options retry: 3, queue: :normal
  end
end
