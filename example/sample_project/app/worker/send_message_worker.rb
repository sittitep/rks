class BroadcastMessageWorker < RKS::Worker
  def perform(args)
    puts "=" * 10
    puts "Broadcasting, #{args['message']} by #{args['name']}"
    puts "=" * 10
  end
end
