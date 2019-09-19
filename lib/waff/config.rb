module Waff
  class Config
    DEFAULT_BACKLOG_LABEL = 'backlog'
    DEFAULT_READY_LABEL = 'to do'
    DEFAULT_IN_PROGRESS_LABEL = 'in progress'

    REMOTE_NOT_FOUND = <<-EOF
      Can't find owner and repository. Make sure the remote name is correctly set on the configuration file.
    EOF

    class << self
      def user
        config['user']
      end

      def token
        config['token']
      end

      def remote
        config['remote']
      end

      def get_owner_and_repo
        url = `git config --get remote.#{remote}.url`.strip
        url[/:(.*)\.git/, 1] || raise(REMOTE_NOT_FOUND)
      end

      def backlog_label
        config['backlog_label'] || 'backlog'
      end

      def ready_label
        config['ready_label'] || DEFAULT_READY_LABEL
      end

      def in_progress_label
        config['in_progress_label'] || 'in progress'
      end

      def init_config!
        return if File.exist?(CONFIG_FILE)

        puts "No config file detected (#{CONFIG_FILE}). Will generate one now in current directory."

        print 'Github username: '
        user = $stdin.gets

        print 'Github password/personal token: '
        token = $stdin.gets

        print 'Git remote (leave empty for "origin"): '
        remote = $stdin.gets.strip
        remote = remote.empty? ? 'origin' : remote

        print "Backlog label (leave empty for '#{DEFAULT_BACKLOG_LABEL}'): "
        backlog_label = $stdin.gets.strip
        backlog_label = backlog_label.empty? ? DEFAULT_BACKLOG_LABEL : backlog_label

        print "Ready label (leave empty for '#{DEFAULT_READY_LABEL}'): "
        ready_label = $stdin.gets.strip
        ready_label = ready_label.empty? ? DEFAULT_READY_LABEL : ready_label

        print "In Progress label (leave empty for '#{DEFAULT_IN_PROGRESS_LABEL}'): "
        in_progress_label = $stdin.gets.strip
        in_progress_label = in_progress_label.empty? ? DEFAULT_IN_PROGRESS_LABEL : in_progress_label

        # Write config file
        File.open(CONFIG_FILE, 'w') do |file|
          file.puts "user: '#{user}'"
          file.puts "token: '#{token}'"
          file.puts "remote: '#{remote}'"
          file.puts "backlog_label: '#{backlog_label}'"
          file.puts "ready_label: '#{ready_label}'"
          file.puts "in_progress_label: '#{in_progress_label}'"
        end

        # Write exclude file
        FileUtils.mkdir_p(File.dirname(EXCLUDE_FILE))
        File.open(EXCLUDE_FILE, 'a+') do |file|
          unless file.read =~ /^#{CONFIG_FILE}$/
            file.puts CONFIG_FILE
          end
        end
      end

      private

      def config
        @config ||= YAML.load_file(CONFIG_FILE)
      end
    end
  end
end
