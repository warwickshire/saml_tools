require_relative '../../test_helper'

module SamlTool
  class DecoderTest < Minitest::Test

    def test_class_decode
      deflated_saml = deflate saml
      encoded_saml = Base64.encode64 deflated_saml
      assert_equal Decoder.new(encoded_saml).decode, Decoder.decode(encoded_saml)
    end

    def test_decode
      deflated_saml = deflate saml
      encoded_saml = Base64.encode64 deflated_saml
      decoded_saml = Decoder.new(encoded_saml).decode
      assert_equal saml, decoded_saml
    end

    def test_base64
      encoded_saml = Base64.encode64 saml
      decoded_saml = Decoder.new(encoded_saml).base64
      assert_equal saml, decoded_saml
    end

    def test_zlib
      deflated_saml = deflate saml
      decoded_saml = Decoder.new(deflated_saml).zlib
      assert_equal saml, decoded_saml
    end

    def deflate(text)
      Zlib::Deflate.deflate(text, Zlib::BEST_COMPRESSION)[2..-5]
    end

  end
end
