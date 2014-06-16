
module SamlTool
  class Reader
    attr_reader :saml, :config

    def initialize(saml, config = {})
      @saml = SamlTool::SAML(saml)
      @config = Hashie::Mash.new(config)
      build_methods
    end


    def build_methods
      @config.each do |key, value|
        self.class.send :attr_reader, key.to_sym
        instance_variable_set("@#{key}".to_sym, saml.xpath(value).to_s)
      end
    end

  end
end