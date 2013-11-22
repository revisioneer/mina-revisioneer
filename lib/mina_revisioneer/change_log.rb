require "json"
require "rugged"

module MinaRevisioneer
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
  end
end