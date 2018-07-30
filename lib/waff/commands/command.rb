module Waff
  module Commands
    class Command
      attr_reader :params

      def self.call *args
        new.call(*args)
      end

      def github_repo
        @github_repo ||= Repository.new
      end
    end
  end
end
