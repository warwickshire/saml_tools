
module SamlTool
  class Encoder
    attr_reader :saml
    attr_accessor :output

    def initialize(saml)
      @saml = saml
      @output = @saml.clone
    end

    def encode
      zlib
      base64
      output
    end

    def base64
      self.output = Base64.encode64 output
    end

    def zlib
      self.output = Zlib::Deflate.deflate(output, Zlib::BEST_COMPRESSION)[2..-5]
    end

  end
end
