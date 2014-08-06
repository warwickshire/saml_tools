require_relative '../../test_helper'

module SamlTool
  class SignatureTest < Minitest::Test
    
    def test_signing_a_document
      doc_signature = signature.generate_for(document)
      assert private_key.verify(digest, doc_signature, document), 'generated signature should be verifable by private key'
      assert public_key.verify(digest, doc_signature, document), 'generated signature should be verifable by public key'
      assert_equal false, other_key.verify(digest, doc_signature, document), 'generated signature should not be verifable by other key'
    end
    
    def test_verify
      doc_signature = private_key.sign(digest, document)
      assert signature.verify(doc_signature, document), 'should verify signature when initiated with private key'
      assert public_signature.verify(doc_signature, document), 'should verify signature when initiated with public key'
      assert_equal false, other_signature.verify(doc_signature, document), 'should not verify signature when initiated with other key'
    end

    def signature
      @signature ||= Signature.new(
        key: private_key,
        digest: digest
      )
    end

    def public_signature
      @public_signature ||= Signature.new(
        key: public_key,
        digest: digest
      )
    end

    def other_signature
      @other_signature ||= Signature.new(
        key: other_key,
        digest: digest
      )
    end

    def private_key
      @private_key ||= OpenSSL::PKey::RSA.new(2048)
    end

    def public_key
      @public_key ||= OpenSSL::PKey::RSA.new private_key.public_key
    end

    def other_key
      @other_key ||= OpenSSL::PKey::RSA.new(2048)
    end

    def digest
      @digest ||= OpenSSL::Digest::SHA256.new
    end

    def document
      @document ||= 'This is a really interesting bit of text. No it is! Honest!'
    end

  end
end
