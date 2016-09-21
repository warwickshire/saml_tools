# Decodes base64 and unzips content.
module SamlTool
  class Decoder
    attr_reader :saml
    attr_accessor :output

    def self.decode(encoded_saml)
      new(encoded_saml).decode
    end

    def initialize(encoded_saml)
      @saml = encoded_saml
      @output = @saml.clone
    end

    def decode
      base64
      zlib
      output
    end

    def base64
      self.output = Base64.decode64 output
    end

    def zlib
      zstream  = Zlib::Inflate.new(-Zlib::MAX_WBITS) # I have no idea why we're using minus Zlib::MAX_WBITS. Zlib documentation suggests just Zlib::MAX_WBITS should work, but it doesn't
        self.output = zstream.inflate(output)
      zstream.finish
      zstream.close
      return output
    end

  end
end
