require_relative '../../test_helper'
require "openssl"

module SamlTool
  class ResponseReaderTest < Minitest::Test
    
    def test_saml
      assert_kind_of SAML::Document, response_document.saml
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
      expected = Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0
      assert_equal expected, response_document.canonicalization_algorithm
    end
    
    def test_reference_uri
      expected = response_document_saml.xpath('//ds:Reference/@URI', { 'ds' => dsig })
      assert_equal expected.to_s, response_document.reference_uri
    end

    def response_document
      @response_document ||= ResponseReader.new(response_xml)
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
