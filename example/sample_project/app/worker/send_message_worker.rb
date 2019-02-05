class BroadcastMessageWorker < RKS::Worker
  def perform(args)
    puts "Broadcasting, #{args['message']} by #{args['name']}"
  end
end
