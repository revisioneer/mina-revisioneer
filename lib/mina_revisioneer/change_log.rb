require "json"
require "rugged"

module MinaRevisioneer
  # Uses the first line of each commit message as entries to the changelog
  #
  # can be configured by setting
  #   :revisioneer_inclusion
  # for inclusiong (whitelisting) and
  #   :revisioneer_exclusion
  # for exlusion (blacklisting)
  class ChangeLog < MessageExtractor
    def messages
      walker = Rugged::Walker.new(repo)
      walker.push sha
      walker.hide last_deploy_sha
      messages = walker.each.to_a.map(&:message)
      messages.select! { |line| line =~ revisioneer_inclusion } if revisioneer_inclusion
      messages.reject! { |line| line =~ revisioneer_exclusion } if revisioneer_exclusion
      messages
    end

    def revisioneer_inclusion
      eval "revisioneer_inclusion", binding
    end

    def revisioneer_exclusion
      eval "revisioneer_exclusion", binding
    end
  end
end