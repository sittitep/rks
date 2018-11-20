require_relative "../test_helper"

class Foo 
  include RKS::Support::Routable
end

class FooFoo
  def foo
    "foo"
  end
end

Foo.router.draw do |r|
  r.on "foo-bar", to: "FooFoo#foo"
end

class TestRoutable < Minitest::Test
  def setup
    @foo = Foo
  end

  def test_find
    assert_equal Hash, Foo.router.find("foo-bar").class
  end

  def test_raise_route_not_found
    assert_raises RKS::Support::Routable::Router::RouteNotFound do 
      assert_equal Hash, Foo.router.find("foo-bar-baz").class
    end
  end
end
