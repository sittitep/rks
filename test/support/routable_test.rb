require_relative "../test_helper"

class Foo
  include RKS::Support::Routable

  def foo
    "foo"
  end
end

Foo.router.draw do |r|
  r.on "foo-bar", to: "Foo#foo"
  r.on "foo-bar-baz", to: "Foo#boo"
end

class TestRoutable < Minitest::Test
  def setup
    @foo = Foo
  end

  def test_route
    assert_equal "foo", Foo.route("foo-bar")
    
    assert_raises RKS::Support::Routable::NoMethodFound do
      Foo.route("foo-bar-baz")
    end

    assert_raises RKS::Support::Routable::Router::RouteNotFound do
      Foo.route("foo-bar-baz-boo-bor")
    end
  end
end
