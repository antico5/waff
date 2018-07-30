require_relative 'command'

module Waff
  module Commands
    class Pause < Command
      def call params
        issue_number = params.shift
        issue = github_repo.get_issue issue_number

        issue.mark_ready!
      end
    end
  end
end
