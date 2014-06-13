module SamlTool

  class << self
    # Parse XML.  Convenience method for Nokogiri::XML::Document.parse
    # but defaults to strict mode
    def SAML thing, url = nil, encoding = nil, options = SAML::ParseOptions::DEFAULT_SAML, &block
      SAML::Document.parse(thing, url, encoding, options, &block)
    end
  end
  
  # A wrapper for Nokogiri::XML, that applies defaults that are appropriate for SAML
  module SAML
    
    class ParseOptions < Nokogiri::XML::ParseOptions
      DEFAULT_SAML = STRICT
    end
    
    class Document < Nokogiri::XML::Document
      def self.parse string_or_io, url = nil, encoding = nil, options = ParseOptions::DEFAULT_SAML, &block
        super
      end
    end
    
    # Parse XML.  Convenience method for Nokogiri::XML::Document.parse
    def self.parse thing, url = nil, encoding = nil, options = ParseOptions::DEFAULT_SAML, &block
      Document.parse(thing, url, encoding, options, &block)
    end
    
  end
end
