class Issue
  attr_reader :repository, :number, :title, :labels, :body

  def initialize(repository, json)
    data = JSON.parse json
    @repository = repository
    @number = data['number']
    @title = data['title']
    @body = data['body']
    parse_labels data
  end

  def create_local_branch!
    branch_name = "##{number}-#{Helper.slug title}"
    puts "Creating branch #{branch_name}"
    `git co -b '#{branch_name}'`
  end

  def assign_to_self!
    repository.assign_issue number
  end

  def mark_in_progress!
    repository.mark_in_progress self
  end

  private

  def parse_labels(data)
    @labels = data['labels'].map { |label| label['name'] }
  end
end
