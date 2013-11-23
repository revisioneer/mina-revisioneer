require "mina_revisioneer/version"
require "mina_revisioneer/message_extractor"
require "mina_revisioneer/change_log"
require "mina_revisioneer/grouped_change_log"
require "mina_revisioneer/notifier"

# # Modules: Revisioneer
# Adds settings and tasks for interfacing with Revisioneer
#
#     require 'mina-revisioneer'

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### revisioneer_host
# Sets the revisioneer host.

set_default :revisioneer_host, 'https://revisions.deployed.eu'

# ### revisioneer_api_token
# Sets the api_token required by revisioneer

set_default :revisioneer_api_token, ''

# ### revisioneer_message_generator
# Sets a class used  to extra the current sha, as well as
# changeset messages. If you want to implement different message
# styles, this is the place to go
set_default :revisioneer_message_generator, -> { ::MinaRevisioneer::ChangeLog.new(revisioneer_host, revisioneer_api_token, binding) }

# ## Deploy tasks
# These tasks are meant to be invoked inside deploy scripts, not invoked on
# their own.

namespace :revisioneer do
  # ### revisioneer:notify
  # notifies revisioneer of a new deployment
  desc "notifies revisioneer of a new deployment"
  task :notify do
    payload = {
      "sha" => revisioneer_message_generator.sha,
      "messages" => revisioneer_message_generator.messages
    }
    queue %{
      echo "-----> Notifying revisioneer"
      #{echo_cmd %[curl  -X POST "#{revisioneer_host}/deployments" -d '#{JSON.dump(payload)}' -H "API-TOKEN: #{revisioneer_api_token}" -H "Content-Type: application/json" -s]}
    }
  end
end