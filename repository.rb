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
      Issue.new(self, response.body)
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

  def mark_in_progress(issue)
    labels = (issue.labels + ['in progress'] - ['ready']).uniq

    url = github_url ['issues', issue.number, 'labels']
    response = self.class.put url, body: labels.to_json
    if response.success?
      puts "Successfully assigned 'in progress' label to  ##{issue.number}"
    else
      puts 'ERROR setting issue labels'
      puts response.body
    end
  end

  private

  def github_url(nodes)
    subpath = nodes.join '/'
    "https://api.github.com/repos/#{@owner_and_repo}/" + subpath
  end
end
