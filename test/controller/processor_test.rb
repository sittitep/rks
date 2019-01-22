require_relative "../test_helper"
require 'ostruct'

class TestController < RKS::Controller::Base
  def test
    request.params["data"]
  end
end

RKS::Controller::Handler.router.draw do |r|
  r.on "test-processor-controller", to: "TestController#test"
end


class TestProcessorController < Minitest::Test
  def setup
    @request = OpenStruct.new
    @request.params = {"data" => "baz"}

    @processor = RKS::Controller::Processor.new(correlation_id: "foo", path: "test-processor-controller", request: @request)
  end

  def test_set_current_processor
    assert_equal @processor, RKS::Controller::Processor.current
  end

  def test_current_processor_attributes
    assert_equal "foo", RKS::Controller::Processor.current.correlation_id
    assert_equal "test-processor-controller", RKS::Controller::Processor.current.path
    assert_equal @request, RKS::Controller::Processor.current.request
  end

  def test_process
    assert_equal "baz", RKS::Controller::Processor.process(correlation_id: "foo", path: "test-processor-controller", request: @request)
  end

  def test_processor_not_initialized
    RKS::Controller::Processor.instance_variable_set(:@current, nil)

    assert_raises RKS::Controller::Processor::ProcessorNotInitialized do
      RKS::Controller::Processor.current
    end
  end
end
