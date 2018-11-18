require_relative "../test_helper"

class Foo < RKS::Event::Base
  def bar
    "baz"
  end

  def barbar
    payload + 1
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
    assert_equal "baz", @handler.call(key: 1, event: "foo-baz", payload: {})
  end

    def test_call_with_payload
    assert_equal 2, @handler.call(key: 1, event: "foo-baz-baz", payload: 1)
  end
end
