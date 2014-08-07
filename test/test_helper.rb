$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'minitest'
require 'minitest/autorun'
require 'saml_tool'

class Minitest::Test

  def valid_saml_request
    contents_of 'files/valid_saml_request.xml'
  end

  def request_saml_erb
    contents_of 'files/request.saml.erb'
  end
  
  def response_xml
    contents_of 'files/response.xml'
  end

  def contents_of(file_path)
    File.read File.expand_path(file_path, File.dirname(__FILE__))
  end
  
  def valid_xml
    '<foo>bar</foo>'
  end

  def saml
    '<foo>something that behaves like saml</foo>'
  end

end
