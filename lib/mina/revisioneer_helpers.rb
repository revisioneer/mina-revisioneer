require "json"
require "rugged"

module Mina
  module RevisioneerHelpers
    def last_deploy
      @last_deploy ||= begin
        curl = %Q{curl "#{revisioneer_host}/deployments?limit=1" -H "API-TOKEN: #{revisioneer_api_token}" -s}
        response = %x[#{curl}].strip
        JSON.parse(response).first
      end
    rescue => err
      puts err
      # no JSON received - first deploy?
      {}
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

    def deploy_messages
      walker = Rugged::Walker.new(repo)
      walker.push current_sha
      walker.hide last_deploy_sha
      messages = walker.each.to_a.map(&:message)
      messages.select! { |line| line =~ revisioneer_inclusion } if revisioneer_inclusion
      messages.reject! { |line| line =~ revisioneer_exclusion } if revisioneer_exclusion
      messages
    end

    def current_sha
      ref = repo.head
      ref.target
    end
  end
end

__END__
require "rugged"
repo = Rugged::Repository.new(".")
commit = Rugged::Commit.lookup repo, repo.head.target