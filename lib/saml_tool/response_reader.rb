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
        digest_value:            '//ds:DigestValue/text()',
        signature_value:         '//ds:SignatureValue/text()',
        signature_algorithm:     '//ds:SignatureMethod/@Algorithm',
        signed_info:             '//ds:SignedInfo'
      }
    end

    def initialize(saml, config = {}, namespaces = {})
      super(
        saml,
        config.merge(default_config),
        namespaces.merge(default_namespaces)
      )
    end

    def attribute_names
      @attribute_names ||= saml.xpath("//saml:Attribute/@Name").collect(&:value)
    end

    # A hash with the attribute names as keys, and the matching attribute value content as values.
    # Note that if the same Name is assigned to more than one attribute or an attribute contains more than
    # one value, then the value for that key will be an array.
    def attributes
      @attributes ||= attribute_names.inject({}) do |hash, name|
        attribute_values = saml.xpath("//saml:Attribute[@Name='#{name}']/saml:AttributeValue/text()")
        hash[name] = attribute_values.length > 1 ? attribute_values.collect(&:to_s) : attribute_values.to_s
        hash
      end
    end

    def valid?
      structurally_valid? && signature_verified? && digests_match?
    end

    def structurally_valid?
      Validator.new(saml.to_s).valid?
    end

    def signature_verified?
      certificate.public_key.verify(
        signature_algorithm_class.new,
        signature,
        canonicalized_signed_info
      )
    end

    def digests_match?
      digest_hash == decoded_digest_value
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

    def signature
      @signature ||= Base64.decode64(signature_value)
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

    def canonicalized_signed_info
      signed_info_element.canonicalize(
        canonicalization_algorithm,
        inclusive_namespaces.split(' ')
      )
    end

    def signed_info_element
      signed_info.source.first
    end

    def digest_algorithm_class
      @digest_algorithm_class ||= determine_algorithm_class(digest_algorithm)
    end

    def signature_algorithm_class
      @signature_algorithm_class ||= determine_algorithm_class(signature_algorithm)
    end

    def determine_algorithm_class(method_text)
      case method_text.slice(/sha(\d+)\s*$/, 1)
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
        ec: c14m
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
