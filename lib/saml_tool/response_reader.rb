require "openssl"

module SamlTool
  class ResponseReader < Reader
    
    # On creation, the keys for this hash will be converted into methods that
    # will return the text gathered at the xpath in the matching value.
    def default_config
      {
        base64_cert:             '//ds:X509Certificate/text()',
        canonicalization_method: '//ds:CanonicalizationMethod/@Algorithm',
        reference_uri:           '//ds:Reference/@URI',
        inclusive_namespaces:    '//ec:InclusiveNamespaces/@PrefixList',
        digest_algorithm:        '//ds:DigestMethod/@Algorithm',
        digest_value:            '//ds:DigestValue/text()'
      }
    end 
    
    def initialize(saml, config = {}, namespaces = {})    
      super(
        saml,
        config.merge(default_config),
        namespaces.merge(default_namespaces)
      )
    end
    
    def signatureless
      @signatureless ||= clone_saml_and_remove_signature
    end
    
    def certificate
      @certificate ||= OpenSSL::X509::Certificate.new(raw_cert)
    end
    
    def raw_cert
      @raw_cert ||= Base64.decode64(base64_cert)
    end
    
    def fingerprint
      @fingerprint ||= Digest::SHA1.hexdigest(certificate.to_der)
    end
    
    def canonicalization_algorithm
      case canonicalization_method
        when "http://www.w3.org/TR/2001/REC-xml-c14n-20010315" then Nokogiri::XML::XML_C14N_1_0
        when "http://www.w3.org/2006/12/xml-c14n11"            then Nokogiri::XML::XML_C14N_1_1
        else                                                        Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0
      end
    end
    
    def hashed_element
      @hashed_element ||= signatureless.at_xpath("//*[@ID='#{reference_uri[1..-1]}']")
    end
    
    def canonicalized_hashed_element
      hashed_element.canonicalize(
        canonicalization_algorithm, 
        inclusive_namespaces.split(' ')
      )
    end
    
    def digest_algorithm_class
      @digest_algorithm_class ||= determine_digest_algorithm_class
    end
  
    def determine_digest_algorithm_class
      case digest_algorithm.slice(/sha(\d+)\s*$/, 1)
      when '256' then OpenSSL::Digest::SHA256
      when '384' then OpenSSL::Digest::SHA384
      when '512' then OpenSSL::Digest::SHA512
      else
        OpenSSL::Digest::SHA1
      end
    end
    
    def digest_hash
      @digest_hash ||= digest_algorithm_class.digest(canonicalized_hashed_element)
    end
    
    def decoded_digest_value
      Base64.decode64(digest_value)
    end

    def clone_saml_and_remove_signature
      cloned_saml = saml.clone
      cloned_saml.xpath('//ds:Signature', namespaces).remove
      return SamlTool::SAML(cloned_saml.to_s)
    end
    
    def default_namespaces
      {
        ds: dsig,
        ec: c14m,
        saml: saml_namespace
      }
    end
    
    def c14m
      'http://www.w3.org/2001/10/xml-exc-c14n#'
    end
        
    def dsig
      'http://www.w3.org/2000/09/xmldsig#'
    end

    def saml_namespace
      'urn:oasis:names:tc:SAML:2.0:assertion'
    end
  end
end
