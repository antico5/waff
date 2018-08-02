require_relative 'command'
require_relative '../os'

module Waff
  module Commands
    class Open < Command
      def call params
        issue_number = params.shift || LocalRepository.current_issue_number
        issue_number || raise('No issue number given as argument or found as current branch')

        open_in_browser github_repo.issue_url(issue_number)
      end

      private

      def open_in_browser url
        `xdg-open #{url}` if OS.linux?
        `open #{url}` if OS.mac?
      end
    end
  end
end
