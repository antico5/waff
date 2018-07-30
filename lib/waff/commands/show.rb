require_relative 'command'

module Waff
  module Commands
    class Show < Command
      def call params
        issue_number = params.shift || LocalRepository.current_issue_number
        issue_number || raise('No issue number given as argument or found as current branch')
        issue = github_repo.get_issue issue_number

        puts "##{issue.number}\t #{issue.title}\n\n"
        puts issue.body
      end
    end
  end
end
