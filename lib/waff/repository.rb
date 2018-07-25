module Waff
  class Repository
    include HTTParty

    def initialize
      @user = Config.user
      @token = Config.token
      @owner_and_repo = Config.get_owner_and_repo

      self.class.basic_auth @user, @token
    end

    def get_issue(number)
      response = self.class.get github_url ['issues', number]

      if response.success?
        Issue.new(self, JSON.parse(response.body))
      else
        puts 'ERROR requesting issue'
        puts response.body
      end
    end

    def assign_issue(number)
      url = github_url ['issues', number, 'assignees']
      response = self.class.post url, body: { assignees: [@user] }.to_json
      if response.success?
        puts "Successfully assigned issue ##{number} to #{@user}."
      else
        puts 'ERROR assigning user to issue'
        puts response.body
      end
    end

    def export_labels issue
      url = github_url ['issues', issue.number, 'labels']
      response = self.class.put url, body: issue.labels.to_json
      if response.success?
        puts "Successfully assigned #{issue.labels.inspect} labels to  ##{issue.number}"
      else
        puts 'ERROR setting issue labels'
        puts response.body
      end
    end

    def get_open_issues label
      response = self.class.get github_url(['issues']), query: { labels: label }

      if response.success?
        issues_data = JSON.parse response.body
        issues_data.reject! { |data| data['pull_request'] }
        issues_data.map { |data| Issue.new(self, data) }
      else
        puts 'ERROR requesting open issues'
        puts response.body
      end
    end

    private

    def github_url(nodes)
      subpath = nodes.join '/'
      "https://api.github.com/repos/#{@owner_and_repo}/" + subpath
    end
  end
end
