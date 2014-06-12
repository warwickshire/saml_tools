# Namespace definition

require 'nokogiri'
require 'hashie'
require 'securerandom'
require 'base64'
require 'zlib'

module SamlTool
  require_relative 'saml_tool/validator'
  require_relative 'saml_tool/erb_builder'
  require_relative 'saml_tool/encoder'
  require_relative 'saml_tool/redirect'
end
