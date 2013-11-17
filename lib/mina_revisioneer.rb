require "mina_revisioneer/version"
require "json"

# # Modules: Revisioneer
# Adds settings and tasks for interfacing with Revisioneer
#
#     require 'mina-revisioneer'

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### revisioneer_host
# Sets the revisioneer host.

module Mina
  module RevisioneerHelpers
    def last_deploy_date
      curl = %Q{curl "#{revisioneer_host}/deployments?limit=1" -H "API-TOKEN: #{revisioneer_api_token}" -s}
      response = %x[#{curl}].strip
      Date.parse(JSON.parse(response).first.fetch("deployed_at"))
    rescue
      # no JSON received - first deploy?
      ""
    end

    def deploy_messages
      %x[git log --pretty=format:'%s' --abbrev-commit --since '#{last_deploy_date}'].strip.lines.map(&:strip)
    end

    def current_sha
      %x[git rev-parse --verify HEAD].strip
    end
  end
end

include Mina::RevisioneerHelpers

set_default :revisioneer_host, 'https://revisioneer.io'

# ### revisioneer_api_token
# Sets the api_token required by revisioneer

set_default :revisioneer_api_token, ''

# ## Deploy tasks
# These tasks are meant to be invoked inside deploy scripts, not invoked on
# their own.

namespace :revisioneer do
  # ### revisioneer:notify
  # notifies revisioneer of a new deployment
  desc "notifies revisioneer of a new deployment"
  task :notify do
    queue %{
      echo "-----> Notifying revisioneer"
      #{echo_cmd %[curl -X POST "#{revisioneer_host}/deployments" -d '{ "sha": "#{revisioneer_sha}", "messages": #{JSON.dump(deploy_messages)} }' -H "API-TOKEN: #{revisioneer_api_token}"]}
    }
  end
end