require_relative "../test_helper"

class Foo < RKS::Event::Base
  def bar
    "baz"
  end

  def barbar
    payload["foo"] + 1
  end
end

RKS::Event::Handler.router.draw do |r|
  r.on "foo-baz", to: "Foo#bar"
  r.on "foo-baz-baz", to: "Foo#barbar"
end

class TestHandler < Minitest::Test
  def setup
    @handler = RKS::Event::Handler
  end

  def test_call
    assert_equal "baz", @handler.call(correlation_id: 1, event: "foo-baz", payload: {foo: "bar"}.to_json)
  end

    def test_call_with_payload
    assert_equal 2, @handler.call(correlation_id: 1, event: "foo-baz-baz", payload: {foo: 1}.to_json)
  end
end
