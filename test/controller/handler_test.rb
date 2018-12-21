require_relative "../test_helper"

class FooController < RKS::Controller::Base
  def bar
    "baz"
  end

  def barbar
    request[:foo] + 1
  end
end

RKS::Controller::Handler.router.draw do |r|
  r.on "foo-baz", to: "FooController#bar"
  r.on "foo-baz-baz", to: "FooController#barbar"
end

class TestControllerHandler < Minitest::Test
  def setup
    @handler = RKS::Controller::Handler
  end

  def test_call
    assert_equal "baz", @handler.call(correlation_id: 1, path: "foo-baz", request: {foo: "bar"})
  end

  def test_call_with_request
    assert_equal 2, @handler.call(correlation_id: 1, path: "foo-baz-baz", request: {foo: 1})
  end
end
