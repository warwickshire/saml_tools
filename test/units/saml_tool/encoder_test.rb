require_relative '../../test_helper'

module SamlTool
  class EncoderTest < Minitest::Test

    def test_class_encode
      encoded_saml = Encoder.encode(saml)
      inflate Base64.decode64(encoded_saml)
      assert_equal saml, @inflated
    end

    def test_encode
      encoded_saml = Encoder.new(saml).encode
      inflate Base64.decode64(encoded_saml)
      assert_equal saml, @inflated
    end

    def test_base64
      encoded_saml = Encoder.new(saml).base64
      assert_equal Base64.encode64(saml), encoded_saml
    end

    def test_zlib
      encoded_saml = Encoder.new(saml).zlib
      inflate encoded_saml
      assert_equal saml, @inflated
    end

    def inflate(encoded)
      zstream  = Zlib::Inflate.new(-Zlib::MAX_WBITS) # I have no idea why we're using minus Zlib::MAX_WBITS. Zlib documentation suggests just Zlib::MAX_WBITS should work, but it doesn't
        @inflated = zstream.inflate(encoded)
      zstream.finish
      zstream.close
    end

  end
end
