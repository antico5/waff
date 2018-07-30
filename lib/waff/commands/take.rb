require_relative 'command'

module Waff
  module Commands
    class Take < Command
      def call params
        issue_number = params.shift
        issue = github_repo.get_issue issue_number

        issue.create_local_branch!
        issue.assign_to_self!
        issue.mark_in_progress!
      end
    end
  end
end
