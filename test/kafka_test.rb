require_relative "./test_helper"

Kafka.configure do |config|
  config.foo = "foo"
  config.brokers = ["localhost"]
end

class TestKafka < Minitest::Test
  def test_config
    assert_equal "foo", Kafka.config.foo
  end

  def test_client
    assert Kafka.client
    assert Kafka.client(new: true)
  end

  def test_producer
    assert Kafka.producer
  end

  def test_consumer
    assert Kafka.consumer
  end
  # def test_execute_job
  #   @mgr = Minitest::Mock.new
  #   @mgr.expect(:options, {:queues => ['default']})
  #   @mgr.expect(:options, {:queues => ['default']})
  #   @mgr.expect(:options, {:queues => ['default']})

  #   assert_equal 2, Sidekiq::Processor.new(@mgr).execute_job(FooWorker.new, [{"correlation_id" => "123", "foo" => 1}])
  # end
end
