require_relative 'command'

module Waff
  module Commands
    class List < Command
      def call params
        [
          ['Backlog', Config.backlog_label],
          ['Ready', Config.ready_label],
          ['In Progress', Config.in_progress_label]
        ].each do |(label_title, label)|
          issues = github_repo.get_open_issues label
          puts "#{label_title}: \n\n"
          issues.each { |issue| puts "##{issue.number}\t #{issue.title}" }
          puts
        end
      end
    end
  end
end
