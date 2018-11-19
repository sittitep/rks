require_relative "../test_helper"



class TestProcessor < Minitest::Test
  def setup
    @processor = RKS::Event::Processor.new(correlation_id: "foo", event: "bar", payload: "baz")
  end

  def test_set_current_processor
    assert_equal @processor, RKS::Event::Processor.current
  end

  def test_current_processor_attributes
    assert_equal "foo", RKS::Event::Processor.current.correlation_id
    assert_equal "bar", RKS::Event::Processor.current.event
    assert_equal "baz", RKS::Event::Processor.current.payload
  end

  def test_process
    handler = MiniTest::Mock.new
    handler.expect(:call, nil, [{correlation_id: "foo", event: "bar", payload: "baz"}])

    RKS::Event::Handler.stub :call, handler do
      assert_nil @processor.process
    end
  end
end
