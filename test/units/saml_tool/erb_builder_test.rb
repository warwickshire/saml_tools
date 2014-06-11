require_relative '../../test_helper'

module SamlTool
  class ErbBuilderTest < MiniTest::Unit::TestCase

    def test_erb
      saml = ErbBuilder.new(
        template: '<foo><%= settings %></foo>',
        settings: 'bar'
      )
      assert_equal '<foo>bar</foo>', saml.to_s
    end

    def test_erb_can_create_valid_saml
      saml = ErbBuilder.new(
        template: request_saml_erb,
        settings: settings
      )
      assert_equal true, Validator.new(saml.to_s).valid?
    end


    def settings
      Hashie::Mash.new(
        id:                             ('_' + SecureRandom.uuid),
        issue_instance:                 Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
        assertion_consumer_service_url: 'http://localhost:3000/demo',
        issuer:                         'http://localhost:3000',
        idp_sso_target_url:             'http://localhost:3000/saml/auth',
        idp_cert_fingerprint:           '9E:65:2E:03:06:8D:80:F2:86:C7:6C:77:A1:D9:14:97:0A:4D:F4:4D',
        name_identifier_format:         'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
      # Optional for most SAML IdPs
        authn_context:                  "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

      )
    end

    def thing
      'bar'
    end
  end
end
