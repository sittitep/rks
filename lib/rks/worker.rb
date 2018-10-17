module RKS
  class Worker
    include Sidekiq::Worker

    def self.children
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end
end
