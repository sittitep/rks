require_relative "../test_helper"

class Foo 
  include RKS::Support::Routable
end

class FooFoo
  include RKS::Support::Routable::Endpoint

  def foo
    "foo"
  end
end

Foo.router.draw do |r|
  r.on "foo-bar", to: "FooFoo#foo"
  r.on "foo-bar-baz", to: "FooFoo#boo"
end

class TestRoutable < Minitest::Test
  def setup
    @foo = Foo
  end

  def test_route
    result = Foo.router.find("foo-bar")[:block].call
    assert_equal "foo", result
    
    # assert_raises RKS::Support::Routable::NoMethodFound do
    #   Foo.router.find("foo-bar-baz")
    # end

    assert_raises RKS::Support::Routable::Router::RouteNotFound do
      Foo.router.find("foo-bar-baz-boo-bor")
    end
  end
end
