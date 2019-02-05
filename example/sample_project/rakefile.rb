require "rake/testtask"

namespace :service do
  task :start do
    case ENV["MODE"]
    when "consumer"
      require "./config/load.rb"
      Application.run
    when "worker"
      require 'sidekiq/cli'
      cli = Sidekiq::CLI.instance

      cli.parse(['-r', './config/load.rb'])
      cli.parse(['-C', './config/sidekiq.yml'])
      cli.run
    when "server"
      require "./config/load.rb"
      Application::Server.run
    end
  end
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
end
desc "Run tests"
