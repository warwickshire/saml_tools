require_relative '../../test_helper'

module SamlTool
  class ValidatorTest < MiniTest::Unit::TestCase

    def test_valid
      validator = Validator.new(valid_saml_request)
      assert_equal true, validator.valid?
    end

    def test_valid_failure
      validator = Validator.new('<foo>Not valid SAML</foo>')
      assert_equal false, validator.valid?
    end
  end
end
