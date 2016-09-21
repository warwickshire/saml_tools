$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'minitest'
require 'minitest/autorun'
require 'saml_tool'

class Minitest::Test

  def valid_xml
    '<foo>bar</foo>'
  end

  def saml
    '<foo>something that behaves like saml</foo>'
  end

  def valid_saml_request
    contents_of 'files/valid_saml_request.xml'
  end

  def request_saml_erb
    contents_of 'files/request.saml.erb'
  end

  def response_xml
    contents_of 'files/response.xml'
  end

  def open_saml_request
    contents_of 'files/open_saml_response.xml'
  end

  def response_simple_attributes
    contents_of 'files/response_simple_attributes.xml'
  end

  def x509_certificate
    @x509_certificate ||= OpenSSL::PKCS12.new(
      contents_of('files/usercert.p12'),
      'hello'
    ).certificate
  end

  def open_ssl_rsa_key
    @open_ssl_rsa_key ||= OpenSSL::PKey::RSA.new(
      contents_of('files/userkey.pem'),
      'hello'
    )
  end

  def contents_of(file_path)
    File.read File.expand_path(file_path, File.dirname(__FILE__))
  end

end
