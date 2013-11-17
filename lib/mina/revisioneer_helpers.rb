require "json"

module Mina
  module RevisioneerHelpers
    def last_deploy_date
      curl = %Q{curl "#{revisioneer_host}/deployments?limit=1" -H "API-TOKEN: #{revisioneer_api_token}" -s}
      response = %x[#{curl}].strip
      Time.parse(JSON.parse(response).first.fetch("deployed_at"))
    rescue
      # no JSON received - first deploy?
      ""
    end

    def deploy_messages
      if last_deploy_date != ""
        messages = %x[git log --pretty=format:'%s' --abbrev-commit --since '#{last_deploy_date}']
      else
        messages = %x[git log --pretty=format:'%s' --abbrev-commit]
      end
      messages = messages.strip.lines.map(&:strip)
      messages.select! { |line| line =~ revisioneer_inclusion } if revisioneer_inclusion
      messages.reject! { |line| line =~ revisioneer_exclusion } if revisioneer_exclusion
      messages
    end

    def current_sha
      %x[git rev-parse --verify HEAD].strip
    end
  end
end