module RKS
  class Worker
    include Sidekiq::Worker
    sidekiq_options retry: 3, queue: :normal

    def self.children
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end
end
