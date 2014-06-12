module SamlTool
  class Validator
    attr_reader :saml
    def initialize(saml)
      @saml = saml
    end
    
    def valid?
      validate
      errors.empty?
    end

    def errors
      @errors ||= []
    end

    #
    def validate
      # Need to load schema with other schemas in path
      # see http://ktulu.com.ar/blog/2011/06/26/resolving-validation-errors-using-nokogiri-and-schemas/
      Dir.chdir(schema_path) do
        schema = Nokogiri::XML::Schema(File.read('localised-saml-schema-protocol-2.0.xsd'))

        schema.validate(saml_document).each do |error|
          errors << error.message unless errors.include? error.message
        end
      end
    end

    def schema_path
      File.expand_path('../schema/', File.dirname(__FILE__))
    end

    def saml_document
      @saml_document ||= Nokogiri::XML(saml)
    end


  end
end
