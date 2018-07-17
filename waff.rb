#!/usr/bin/env ruby

require 'httparty'
require 'pry'
require_relative 'core.rb'

CONFIG_FILE = '.waff.yml'

def init_config
  unless File.exist?(CONFIG_FILE)
    puts "No config file detected (#{CONFIG_FILE}). Will generate one now in current directory."
    print 'Github username: '
    user = gets
    print 'Github password/personal token: '
    token = gets
    print 'Git remote (leave empty for "origin"):'
    remote = gets.strip
    remote = remote.empty? ? 'origin' : remote

    File.open(CONFIG_FILE, 'w') do |file|
      file.puts "user: #{user}"
      file.puts "token: #{token}"
      file.puts "remote: #{remote}"
    end
  end
end

init_config


command = ARGV[0]
issue_number = ARGV[1]

case command
when 'take'
  issue = Repository.new.get_issue issue_number
  issue.create_local_branch!
  issue.assign_to_self!
  issue.mark_in_progress!
when 'show'
  issue = Repository.new.get_issue issue_number
  puts issue.body
end
