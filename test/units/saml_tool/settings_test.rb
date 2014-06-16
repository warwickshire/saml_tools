require_relative '../../test_helper'

module SamlTool
  class SettingsTest < Minitest::Test

    def test_creation
      assert_equal 'bar', settings.foo    
    end

    def test_uuid
      assert_match /\_[a-z0-9\-]{36}/, settings.uuid
    end

    def test_user_defined_uuid
      settings = Settings.new(uuid: 'foo')
      assert_equal 'foo', settings.uuid
    end

    def test_issue_instance
      assert_match /\d{4}\-\d{2}\-\d{2}T\d{2}\:\d{2}\:\d{2}Z/, settings.issue_instance
    end

    def test_user_issue_instance
      settings = Settings.new(issue_instance: 'foo')
      assert_equal 'foo', settings.issue_instance
    end

    def settings
      @setting ||= Settings.new(foo: 'bar')
    end
  end
end
