require 'securerandom'
require 'time'
module SamlTool
  class Settings < Hashie::Mash

    def uuid
      fetch :uuid, ('_' + SecureRandom.uuid)
    end

    def issue_instance
      fetch :issue_instance, Time.now.utc.iso8601
    end

  end
end
