
module SamlTool
  class Reader
    attr_reader :saml, :config, :namespaces

    def initialize(saml, config = {}, namespaces = {})
      @saml = SamlTool::SAML(saml)
      @config = Hashie::Mash.new(config)
      @namespaces = namespaces
      build_methods
    end

    def to_hash
      config.keys.inject({}){|hash, key| hash[key.to_sym] = send(key.to_sym); hash}
    end

    private
    def build_methods
      @config.each do |key, value|
        self.class.send :attr_reader, key.to_sym
        source = saml.xpath(value, namespaces)
        content = Content.new(source)
        instance_variable_set("@#{key}".to_sym, content)
      end
    end
    
    # A string with memory of the element that was the source of its content.
    # Typically, the source will be a Nokogiri::XML::NodeSet. So:
    #     content           --> text from an element.
    #     content.source    --> the Nokogiri NodeSet the text was extracted from.
    class Content < String    
      attr_reader :source
      def initialize(source)
        @source = source
        super(source.to_s)
      end
    end

  end
end
