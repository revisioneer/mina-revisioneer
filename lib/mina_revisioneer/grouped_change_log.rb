module MinaRevisioneer
  # Uses the markers inside the commit message to generate change groups
  #
  # can be configured by setting
  #   :revisioneer_markers
  # must be a hash of GroupName => Marker
  class GroupedChangeLog < MessageExtractor
    def messages
      groups = Hash.new

      walker = Rugged::Walker.new(repo)
      walker.push sha
      walker.hide last_deploy_sha if last_deploy_sha
      walker.each do |commit|
        revisioneer_markers.each do |marker, pattern|
          commit.message.lines.each do |line|
            if line =~ pattern
              (groups[marker] ||= []) << line.strip
            end
          end
        end
      end

      messages = []
      groups.each do |key, ms|
        messages << "#{key}:\n#{ms.join("\n")}"
      end
      messages
    end

    def revisioneer_markers
      eval "revisioneer_markers", binding
    end
  end
end