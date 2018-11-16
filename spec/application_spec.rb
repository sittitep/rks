require_relative "./test_helper"

class TestConfigurable < Minitest::Test
  def setup
    @application = Application
  end

  def test_default_config
    assert_equal "regular-rks-app", @application.config.name
    assert_equal "dev", @application.config.env
  end
end
