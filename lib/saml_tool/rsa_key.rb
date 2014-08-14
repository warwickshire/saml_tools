
module SamlTool
  class RsaKey < OpenSSL::PKey::RSA
    
    def modulus
      Base64.encode64(n.to_s(2))
    end
    
    def exponent
      Base64.encode64(e.to_s(2))
    end
  end
end
