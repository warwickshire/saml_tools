require 'securerandom'
require 'time'
module SamlTool
  class Settings < Hashie::Mash

    def uuid
      fetch :uuid, auto_uuid
    end

    def issue_instance
      fetch :issue_instance, auto_issue_instance
    end
    
    private
    def auto_uuid
      @auto_uuid ||= ('_' + SecureRandom.uuid)
    end
    
    def auto_issue_instance
      @auto_issue_instance ||= Time.now.utc.iso8601
    end

  end
end
