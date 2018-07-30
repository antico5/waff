require_relative 'command'

module Waff
  module Commands
    class List < Command
      def call params
        ready_issues = github_repo.get_open_issues 'ready'
        ready_issues += github_repo.get_open_issues 'to do'
        puts "Ready: \n\n"
        ready_issues.each do |issue|
          puts "##{issue.number}\t #{issue.title}"
        end
        puts

        in_progress_issues = github_repo.get_open_issues 'in progress'
        puts "In progress: \n\n"
        in_progress_issues.each do |issue|
          puts "##{issue.number}\t #{issue.title}"
        end
        puts
      end
    end
  end
end
