
module SamlTool
  class Certificate < OpenSSL::X509::Certificate
    
    alias_method :serial_number, :serial
  
    def to_s_without_leading_and_trailing_labels
      to_s.lines.to_a[1..-2].join
    end
    alias_method :x509_certificate, :to_s_without_leading_and_trailing_labels
    
    def issuer_name
      @issuer_name ||= slash_list_to_comma_list(issuer)
    end
    
    def subject_name
      @subject_name ||= slash_list_to_comma_list(subject)
    end
    
    def slash_list_to_comma_list(string)
      string = string.to_s
      string = string[1..-1] if string[0] == '/'
      string.split('/').reverse.join(',')
    end
    
  end
end
