require "openssl"

module SamlTool
  class ResponseReader < Reader
    def initialize(saml, config = {}, namespaces = {})    
      super(
        saml,
        config.merge(default_config),
        namespaces.merge(default_namespaces)
      )
    end
    
    def certificate
      @certificate ||= OpenSSL::X509::Certificate.new(raw_cert)
    end
    
    def raw_cert
      @raw_cert ||= Base64.decode64(base64_cert)
    end
    
    def fingerprint
      @fingerprint||= Digest::SHA1.hexdigest(certificate.to_der)
    end
    
    def default_config
      {
        base64_cert: '//ds:X509Certificate/text()'
      }
    end
    
    def default_namespaces
      {
        ds: dsig
      }
    end
    
    def c14m
      'http://www.w3.org/2001/10/xml-exc-c14n#'
    end
        
    def dsig
      'http://www.w3.org/2000/09/xmldsig#'
    end
  end
end
