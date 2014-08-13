require_relative '../../test_helper'
require "openssl"

module SamlTool
  class ResponseReaderTest < Minitest::Test
    
    def test_saml
      assert_kind_of SAML::Document, response_document.saml
    end
    
    def test_signatureless
      assert_kind_of SAML::Document, response_document.signatureless
      expected = response_document.saml.clone
      expected.xpath('//ds:Signature', { 'ds' => dsig }).remove
      assert_equal expected.to_s, response_document.signatureless.to_s
    end
    
    def test_signatureless_does_not_impact_saml
      response_document.signatureless
      assert response_document.saml.to_s != response_document.signatureless.to_s, 'Changes made in forming signatureless should not also happen to saml'
    end
    
    def test_base64_cert
      base64_cert = response_document_saml.xpath('//ds:X509Certificate/text()', { 'ds' => dsig })
      assert_equal base64_cert.to_s, response_document.base64_cert
    end
    
    def test_certificate
      assert_kind_of OpenSSL::X509::Certificate, response_document.certificate
    end
    
    def test_fingerprint
      expected = Digest::SHA1.hexdigest(response_document.certificate.to_der)
      assert_equal expected, response_document.fingerprint
    end
    
    def test_canonicalization_method
      expected = response_document_saml.xpath('//ds:CanonicalizationMethod/@Algorithm', { 'ds' => dsig })
      assert_equal expected.to_s, response_document.canonicalization_method
    end
    
    def test_canonicalization_algorithm
      expected = Nokogiri::XML::XML_C14N_1_0
      assert_equal expected, response_document.canonicalization_algorithm
    end
    
    def test_reference_uri
      expected = response_document_saml.xpath('//ds:Reference/@URI', { 'ds' => dsig })
      assert_equal expected.to_s, response_document.reference_uri
    end
    
    def test_inclusive_namespaces
      assert_equal "", response_document.inclusive_namespaces
    end
    
    def test_inclusive_namespaces_when_they_exist_in_saml
      document = ResponseReader.new(open_saml_request)
      assert_equal 'xs', document.inclusive_namespaces
    end
    
    def test_hashed_element
      remove_signature_from_assertion
      assert_equal assertion.to_s, response_document.hashed_element.to_s
    end
    
    def test_canonicalized_hashed_element
      remove_signature_from_assertion
      expected = assertion.canonicalize(Nokogiri::XML::XML_C14N_1_0, [])
      assert_equal expected, response_document.canonicalized_hashed_element
    end
    
    def test_digest_algorithm
      assert_equal 'http://www.w3.org/2000/09/xmldsig#sha1', response_document.digest_algorithm
    end
    
    def test_digest_algorithm_class
      assert_equal OpenSSL::Digest::SHA1, response_document.digest_algorithm_class
    end
    
    def test_digest_hash
      expected = OpenSSL::Digest::SHA1.digest(response_document.canonicalized_hashed_element)
      assert_equal expected, response_document.digest_hash
    end
    
    def test_digest_hash_matches_digest_value
      assert_equal response_document.digest_hash, response_document.decoded_digest_value
    end

    def test_digests_match?
      assert_equal true, response_document.digests_match?
    end

    def test_signature
      signature_value = response_document_saml.xpath('//ds:SignatureValue', { 'ds' => dsig }).text
      assert_equal Base64.decode64(signature_value), response_document.signature
    end

    def test_signature_algorithm_class
      assert_equal OpenSSL::Digest::SHA1, response_document.signature_algorithm_class
    end

    def test_canonicalized_signed_info
      expected = response_document.signed_info.source.first.canonicalize(Nokogiri::XML::XML_C14N_1_0, [])
      assert_equal expected, response_document.canonicalized_signed_info
    end

    def test_signature_verified
      assert_equal true, response_document.signature_verified?
    end

    def response_document
      @response_document ||= ResponseReader.new(response_xml)
    end
    
    def assertion
      @assertion ||= response_document_saml.at_xpath('//saml:Assertion')
    end
    
    def remove_signature_from_assertion
      assertion.xpath('//ds:Signature', { 'ds' => dsig }).remove
    end
    
    def response_document_saml
      @response_document_saml ||= SamlTool::SAML(response_xml)
    end
    
    def c14m
      'http://www.w3.org/2001/10/xml-exc-c14n#'
    end
        
    def dsig
      'http://www.w3.org/2000/09/xmldsig#'
    end
    
  end
end
