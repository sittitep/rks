require_relative "../test_helper"

class TestProcessorEvent < RKS::Event::Base
  def test
    payload["data"]
  end
end

RKS::Event::Handler.router.draw do |r|
  r.on "test-processor-event", to: "TestProcessorEvent#test"
end


class TestProcessor < Minitest::Test
  def setup
    @payload = {data: "baz"}.to_json
    @processor = RKS::Event::Processor.new(correlation_id: "foo", event: "test-processor-event", payload: @payload)
  end

  # def test_set_current_processor
  #   assert_equal @processor, RKS::Event::Processor.current
  # end

  # def test_current_processor_attributes
  #   assert_equal "foo", RKS::Event::Processor.current.correlation_id
  #   assert_equal "test-processor-event", RKS::Event::Processor.current.event
  #   assert_equal @payload, RKS::Event::Processor.current.payload
  # end

  def test_process
    assert_equal "baz", RKS::Event::Processor.process(correlation_id: "foo", event: "test-processor-event", payload: @payload)
  end

  # def test_processor_not_initialized
  #   RKS::Event::Processor.instance_variable_set(:@current, nil)

  #   assert_raises RKS::Event::Processor::ProcessorNotInitialized do
  #     RKS::Event::Processor.current
  #   end
  # end
end
