require_relative '../../test_helper'

module SamlTool
  class RedirectTest < MiniTest::Unit::TestCase

    def test_to_s 
      redirect = Redirect.new(
        to: url,
        data: {
          foo: 'bar'
        }
      )
      assert_equal "#{url}?foo=bar", redirect.to_s
    end

    def test_to_s_with_multiple_data
      redirect = Redirect.new(
        to: url,
        data: {
          foo: 'bar',
          this: 'that'
        }
      )
      assert_equal "#{url}?foo=bar&this=that", redirect.to_s
    end

    def test_to_s_with_existing_parameters
      redirect = Redirect.new(
        to: url + '?foo=bar',
        data: {
          this: 'that'
        }
      )
      assert_equal "#{url}?foo=bar&this=that", redirect.to_s
    end

    def test_to_s_with_data_string
      redirect = Redirect.new(
        to: url,
        data: 'foo=bar'
      )
      assert_equal "#{url}?foo=bar", redirect.to_s
    end

    def url
      'http://example.com/saml/auth'
    end

  end
end
