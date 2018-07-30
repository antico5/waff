module Waff
  class Config
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

      private

      def config
        @config ||= YAML.load_file(CONFIG_FILE)
      end
    end
  end
end
