

module SamlTool
  class SamlTest < Minitest::Test
    
    def test_document     
      document = SamlTool::SAML(valid_xml)    
      assert_kind_of Nokogiri::XML::Document, document
    end
    
    def test_parse
      document = SamlTool::SAML.parse valid_xml
      assert_kind_of Nokogiri::XML::Document, document
    end
    
    def test_document_parse
      document = SamlTool::SAML::Document.parse valid_xml
      assert_kind_of Nokogiri::XML::Document, document
    end
  end
end
