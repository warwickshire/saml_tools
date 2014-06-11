# Namespace definition

require 'nokogiri'
require 'hashie'
require 'securerandom'

module SamlTool
  require_relative 'saml_tool/validator'
  require_relative 'saml_tool/erb_builder'
end
