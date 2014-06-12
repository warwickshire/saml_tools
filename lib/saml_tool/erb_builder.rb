require 'erb'
module SamlTool
  class ErbBuilder
    
    attr_reader :args, :settings, :template

    def self.build(args)
      new(args).to_s
    end

    def initialize(args)
      @args = args
      @settings = args[:settings]
      @template = args[:template]
    end

    def to_s
      output
    end

    def output
      @output ||= build_output
    end

    def build_output
      erb.result settings.send(:binding)
    end

    def erb
      ERB.new(template)
    end
  end
end
