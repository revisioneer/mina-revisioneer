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

set_default :revisioneer_host, 'https://revisioneer.io'

# ### revisioneer_api_token
# Sets the api_token required by revisioneer

set_default :revisioneer_api_token, ''

set_default :revisioneer_sha, %x[git rev-parse --verify HEAD].strip

set_default :revisioneer_last_deploy_date, JSON.parse(%x[curl "#{revisioneer_host}/deployments?limit=1" -H "API-TOKEN: #{revisioneer_api_token}"].strip || '{}')["deployed_at"]

set_default :revisioneer_messages, %x[git log --pretty=format:'%s' --abbrev-commit --since '#{revisioneer_last_deploy_date}'].strip.lines

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
      #{echo_cmd %[curl -X POST "#{revisioneer_host}/deployments" -d '{ "sha": "#{revisioneer_sha}", "messages": #{JSON.dump(revisioneer_messages)} }' -H "API-TOKEN: #{revisioneer_api_token}"]}
    }
  end
end