$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'minitest/autorun'
require 'saml_tool'

class MiniTest::Unit::TestCase

  def valid_saml_request
    contents_of 'files/valid_saml_request.xml'
  end

  def request_saml_erb
    contents_of 'files/request.saml.erb'
  end

  def contents_of(file_path)
    File.read File.expand_path(file_path, File.dirname(__FILE__))
  end

end
