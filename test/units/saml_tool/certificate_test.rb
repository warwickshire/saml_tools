require_relative '../../test_helper'

module SamlTool
  class CertificateTest < Minitest::Test
    
    def test_x509_certificate
      expected = x509_certificate.to_s.lines.to_a[1..-2].join
      assert_equal expected, certificate.x509_certificate      
    end

    def test_issuer_name
      expected = x509_certificate.issuer.to_s[1..-1].split('/').reverse.join(',')
      assert_equal expected, certificate.issuer_name
    end
    
    def test_subject_name
      expected = x509_certificate.subject.to_s[1..-1].split('/').reverse.join(',')
      assert_equal expected, certificate.subject_name      
    end
    
    def test_serial_number
      assert_equal x509_certificate.serial, certificate.serial_number
    end
    
    def certificate
      @certificate ||= Certificate.new(x509_certificate)
    end
    
  end
end
