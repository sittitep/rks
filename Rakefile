require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
end
desc "Run tests"

task default: :test
