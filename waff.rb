#!/usr/bin/env ruby

require 'fileutils'
require 'httparty'
require 'pry'
require_relative 'core.rb'

CONFIG_FILE = '.waff.yml'
EXCLUDE_FILE = '.git/info/exclude'

def init_config
  unless File.exist?(CONFIG_FILE)
    puts "No config file detected (#{CONFIG_FILE}). Will generate one now in current directory."
    print 'Github username: '
    user = $stdin.gets
    print 'Github password/personal token: '
    token = $stdin.gets
    print 'Git remote (leave empty for "origin"): '
    remote = $stdin.gets.strip
    remote = remote.empty? ? 'origin' : remote

    # Write config file
    File.open(CONFIG_FILE, 'w') do |file|
      file.puts "user: #{user}"
      file.puts "token: #{token}"
      file.puts "remote: #{remote}"
    end

    # Write exclude file
    FileUtils.mkdir_p(File.dirname(EXCLUDE_FILE))
    File.open(EXCLUDE_FILE, 'a+') do |file|
      unless file.read =~ /^#{CONFIG_FILE}$/
        file.puts CONFIG_FILE
      end
    end

  end
end

def check_local_repository_exists
  unless File.exist?('.git')
    puts 'No git repository found. Please move to the root of your project.'
    exit
  end
end

check_local_repository_exists
init_config


command = ARGV[0]
issue_number = ARGV[1]
repo = Repository.new

case command
when 'take'
  issue = repo.get_issue issue_number
  issue.create_local_branch!
  issue.assign_to_self!
  issue.mark_in_progress!
when 'pause'
  issue = repo.get_issue issue_number
  issue.mark_ready!
when 'list'
  ready_issues = repo.get_open_issues 'ready'
  ready_issues += repo.get_open_issues 'to do'
  puts "Ready: \n\n"
  ready_issues.each do |issue|
    puts "##{issue.number}\t #{issue.title}"
  end
  puts

  in_progress_issues = repo.get_open_issues 'in progress'
  puts "In progress: \n\n"
  in_progress_issues.each do |issue|
    puts "##{issue.number}\t #{issue.title}"
  end
  puts
when 'show'
  issue_number ||= LocalRepository.current_issue_number
  issue_number || raise('No issue number given as argument or found as current branch')
  issue = repo.get_issue issue_number
  puts "##{issue.number}\t #{issue.title}\n\n"
  puts issue.body
end
