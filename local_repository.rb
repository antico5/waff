class LocalRepository
  class << self
    def current_issue_number
      branch_name = `git rev-parse --abbrev-ref HEAD`
      branch_name[/^#?(\d+)-/, 1]
    end
  end
end
