require_relative "../test_helper"

class Foo
  include RKS::Support::Routable

  def foo
    "foo"
  end
end

Foo.router.draw do |r|
  r.on "foo-bar-baz", to: "Foo#foo"
end

class TestRoutable < Minitest::Test
  def setup
    @foo = Foo
  end

  def test_route
    assert_equal "foo", Foo.route("foo-bar-baz")
  end
end
