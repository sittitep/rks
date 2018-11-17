require_relative "../test_helper"

class Foo
  def bar
    "baz"
  end
end

RKS::Event::Handler.router.draw do |r|
  r.on "foo-baz", to: "Foo#bar"
end

class TestHandler < Minitest::Test
  def setup
    @handler = RKS::Event::Handler
  end

  def test_call
    assert_equal "baz", @handler.call("foo-baz")
  end
end
