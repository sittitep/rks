require_relative "./test_helper"
require 'sidekiq/testing' 

Sidekiq::Testing.inline!

class FooWorker
  include Sidekiq::Worker

  def perform(args)
    args["foo"] + 1
  end
end

class TestSidekiq < Minitest::Test
  def test_perform
    args = {"correlation_id" => "123", "foo" => 1}

    assert_equal String, FooWorker.perform_async(args).class
    assert_equal 2, FooWorker.new.perform(args)
  end

  def test_execute_job
    @mgr = Minitest::Mock.new
    @mgr.expect(:options, {:queues => ['default']})
    @mgr.expect(:options, {:queues => ['default']})
    @mgr.expect(:options, {:queues => ['default']})

    assert_equal 2, Sidekiq::Processor.new(@mgr).execute_job(FooWorker.new, [{"correlation_id" => "123", "foo" => 1}])
  end
end
