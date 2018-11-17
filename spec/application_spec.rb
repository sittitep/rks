require_relative "./test_helper"

class TestConfigurable < Minitest::Test
  def test_default_config
    assert_equal "regular-rks-app", Application.config.name
    assert_equal "dev", Application.config.env
  end
end
