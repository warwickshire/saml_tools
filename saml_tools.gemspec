$:.push File.expand_path("../lib", __FILE__)

# Maintain gem's version:
require "saml_tool/version"

Gem::Specification.new do |s|
  s.name        = "saml_tools"
  s.version     = SamlTool::VERSION
  s.authors     = ["Rob Nichols"]
  s.email       = ["rob@undervale.co.uk"]
  s.homepage    = "https://github.com/warwickshire/saml_tools"
  s.summary     = "Tools to simplify the creation, validation and sending of SAML objects"
  s.description = " SAML 2.0 is an XML-based protocol that uses security tokens containing assertions to pass information about a principal (usually an end user) between a SAML authority, that is, an identity provider, and a SAML consumer, that is, a service provider. SAML 2.0 enables web-based authentication and authorization scenarios including cross-domain single sign-on (SSO), which helps reduce the administrative overhead of distributing multiple authentication tokens to the user."
  s.license = 'LICENSE'
  s.files = Dir["lib/**/*"] + ["LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'nokogiri'
  s.add_dependency 'hashie'

end