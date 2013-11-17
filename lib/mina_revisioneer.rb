require "mina_revisioneer/version"

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
      #{echo_cmd %[mkdir -p "#{deploy_to}/#{shared_path}/bundle"]}
      #{echo_cmd %[mkdir -p "#{File.dirname bundle_path}"]}
      #{echo_cmd %[ln -s "#{deploy_to}/#{shared_path}/bundle" "#{bundle_path}"]}
      #{echo_cmd %[#{bundle_bin} install #{bundle_options}]}
    }
  end
end