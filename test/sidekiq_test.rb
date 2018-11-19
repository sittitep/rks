require_relative "./test_helper"

class FooWorker
  include Sidekiq::Worker

  def perform(args)
    args[:foo] + 1
  end
end

class TestConfigurable < Minitest::Test
  def test_perform
    assert_equal 2, Sidekiq::Processor.new.execute_job(FooWorker.new, [{"correlation_id": "123", "foo": 1}])
    assert_equal 2, FooWorker.new.perform(correlation_id: "123", foo: 1)
  end
end
