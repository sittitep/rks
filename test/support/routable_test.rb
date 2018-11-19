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

  def test_find
    assert_equal Hash, Foo.router.find("foo-bar").class
  end
end
