require "json"
require "rugged"

module MinaRevisioneer
  class MessageExtractor
    attr_reader :host, :api_token
    def initialize host, token
      @host = host
      @api_token = token
    end

    def last_deploy
      @last_deploy ||= begin
        curl = %Q{curl "#{host}/deployments?limit=1" -H "API-TOKEN: #{api_token}" -s}
        response = %x[#{curl}].strip
        JSON.parse(response).first
      end
    rescue => err
      {} # no JSON received - propably first deploy?
    end

    def last_deploy_date
      Time.parse(last_deploy.fetch("deployed_at"))
    end

    def last_deploy_sha
      last_deploy.fetch("sha")
    end

    def repo
      @repo ||= Rugged::Repository.new(".")
    end

    def messages
      [] # implemented in subclass
    end

    def sha
      ref = repo.head
      ref.target
    end
  end
end