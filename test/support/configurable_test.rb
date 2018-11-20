require_relative "../test_helper"

class Foo
  include RKS::Support::Configurable
  config_attr bar: false, foo: false
end

class TestConfigurable < Minitest::Test
  def setup
    @foo = Foo
  end

  def test_config_attr
    assert_equal false, @foo.config.bar
  end

  def test_config
    @foo.config.foo = true

    assert_equal false, @foo.config.bar
  end

  def test_configure
    @foo.configure do |config|
      config.baz = true
    end

    assert_equal true, @foo.config.baz
  end

  def test_raise_config_name_not_supported
    assert_raises RKS::Support::Configurable::InvalidConfugurationName do
      @foo.class_eval do
        config_attr "foo"
      end
    end
  end
end
