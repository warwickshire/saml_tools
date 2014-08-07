
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
        contents = saml.xpath(value, namespaces)
        instance_variable_set("@#{key}".to_sym, contents.to_s)
      end
    end

  end
end
