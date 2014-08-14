require_relative '../../test_helper'

module SamlTool
  class RsaKeyTest < Minitest::Test

    def test_modulous
      expected = Base64.encode64(open_ssl_rsa_key.n.to_s(2))
      assert_equal expected, rsa_key.modulus
    end
    
    def test_exponent
      expected = Base64.encode64(open_ssl_rsa_key.e.to_s(2))
      assert_equal expected, rsa_key.exponent
    end
  
    def rsa_key
      @rsa_key ||= RsaKey.new(open_ssl_rsa_key)
    end    
    
  end
end
