#!/usr/bin/env ruby

require 'httparty'
require 'pry'

puts `pwd`
exit

class Helper
  def self.slug(title)
    title.downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '')
  end
end

class LocalRepo
  def self.get_remote_url
    `git config --get remote.#{remote}.url`
  end

  def self.get_owner_and_repo(remote: 'origin')
    url = `git config --get remote.#{remote}.url`.strip
    url[/:(.*)\.git/, 1]
  end
end

class Repository
  include HTTParty

  def initialize(config)
    @user = config[:user]
    @token = config[:token]
    @owner_and_repo = config[:owner_and_repo]

    self.class.basic_auth @user, @token
  end

  def get_issue(number)
    response = self.class.get github_url ['issues', number]

    if response.success?
      Issue.new(self, response.body)
    else
      puts 'ERROR requesting issue'
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

class Issue
  attr_reader :repository, :number, :title, :labels

  def initialize(repository, json)
    data = JSON.parse json
    @repository = repository
    @number = data['number']
    @title = data['title']
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

issue_number = ARGV[0]

config = YAML.load_file('.github_flow.yml').transform_keys &:to_sym
config[:owner_and_repo] = LocalRepo.get_owner_and_repo

issue = Repository.new(config).get_issue issue_number
issue.create_local_branch!
issue.assign_to_self!
issue.mark_in_progress!
