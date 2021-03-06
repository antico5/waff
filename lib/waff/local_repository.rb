module Waff
  class LocalRepository
    class << self
      def current_issue_number
        branch_name = `git rev-parse --abbrev-ref HEAD`
        branch_name[/^#?(\d+)-/, 1]
      end

      def check_existence!
        unless File.exist?('.git')
          raise 'No git repository found. Please move to the root of your project.'
        end
      end
    end
  end
end
