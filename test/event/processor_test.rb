require_relative "../test_helper"

class TestProcessor < Minitest::Test
  def setup
    @processor = RKS::Event::Processor.new(key: "foo", event: "bar", payload: "baz")
  end

  def test_set_current_processor
    assert_equal @processor, RKS::Event::Processor.current
  end

  def test_current_processor_attributes
    assert_equal "foo", RKS::Event::Processor.current.key
    assert_equal "bar", RKS::Event::Processor.current.event
    assert_equal "baz", RKS::Event::Processor.current.payload
  end

  def test_process
    assert_equal nil, @processor.process
  end
end
