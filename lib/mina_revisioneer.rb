require "mina_revisioneer/version"
require "mina/revisioneer_helpers"
include Mina::RevisioneerHelpers

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

# ### revisioneer_inclusion
# Sets a pattern by which git commit messages are filtered.
# Only matching messages will be included
set_default :revisioneer_inclusion, false

# ### revisioneer_exclusion
# Sets a pattern by which git commit messages are filtered.
# Matching messages will be excluded
set_default :revisioneer_exclusion, /\[skip-rev\]/

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
      #{echo_cmd %[curl -X POST "#{revisioneer_host}/deployments" -d '{ "sha": "#{current_sha}", "messages": #{JSON.dump(deploy_messages)} }' -H "API-TOKEN: #{revisioneer_api_token}" -s]}
    }
  end
end