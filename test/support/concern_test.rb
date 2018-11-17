require_relative "../test_helper"

module Bar
  extend RKS::Support::Concern

  module ClassMethods
    def foo
      "foo"
    end
  end

  module InstanceMethods
    def foo
      "foo"
    end
  end
end

class Foo
  include Bar
end

class TestConcern < Minitest::Test
  def setup
    @foo = Foo
  end

  def test_config_attr
    assert_equal "foo", @foo.foo
  end

  def test_config
    assert_equal "foo", @foo.new.foo
  end
end
