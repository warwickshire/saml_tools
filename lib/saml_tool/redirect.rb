require 'uri'
require 'cgi'

#  Used to construct redirection uris
#
#        redirect = Redirect.uri(
#          to: 'http://example.com',
#          data: {
#            foo: 'bar'
#          }
#        )
#        redirect == "http://example.com?foo=bar"
#
module SamlTool

  class Redirect
    attr_reader :to, :data

    def self.uri(args)
      new(args).to_s
    end

    def initialize(args)
      @to = args[:to]
      @data = args[:data]
    end

    def uri
      @uri || build_uri
    end

    def data_string
      return data if data.kind_of? String
      data.to_a.collect{|pair| pair.collect{|p| CGI.escape(p.to_s)}.join('=')}.join('&')
    end

    def append_data
      uri.query = [uri.query, data_string].compact.join('&')
    end

    def to_s
      uri.to_s
    end

    def build_uri
      uri_from_to
      append_data
      return uri
    end

    def uri_from_to
      @uri = URI(to)
    end
  end

end
