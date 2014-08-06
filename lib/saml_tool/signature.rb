# A tool to create and verify signatures used in SAML files.

module SamlTool
  class Signature

    attr_reader :digest, :key

    # Usage
    # -----
    #     signature = SamlTool::Signature.new(key: key, digest: digest)
    #
    # where:
    # [key] is an OpenSSL key such as OpenSSL::PKey::RSA.new(2048)
    # [digest] is an OpenSSL digest such as OpenSSL::Digest::SHA256.new
    #
    # A key can also be generated from the contents of a file:
    #
    #     key = OpenSSL::PKey::RSA.new File.read('public_key.pem')
    #
    def initialize(args = {})
      @key = args[:key]
      @digest = args[:digest]
    end

    def generate_for(document)
      key.sign digest, document
    end

    def verify(signature, document)
      key.verify digest, signature, document
    end

  end
end
