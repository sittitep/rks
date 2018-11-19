require_relative "../test_helper"

class FooCommand < RKS::Command::Base
  def foo
    "bar"
  end
end

class TestCommandHandler < Minitest::Test
  def setup
    @handler = RKS::Command::Handler
  end

  def test_foo
    assert_equal "bar", @handler.call(correlation_id: 1, klass: FooCommand, action: :foo)
  end
end
