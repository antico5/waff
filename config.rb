class Config
  REMOTE_NOT_FOUND = <<-EOF
  Can't find owner and repository. Make sure the remote name is correctly set on the configuration file.
  EOF

  class << self
    def user
      config[:user]
    end

    def token
      config[:token]
    end

    def remote
      config[:remote]
    end

    def get_owner_and_repo
      url = `git config --get remote.#{remote}.url`.strip
      url[/:(.*)\.git/, 1] || raise(REMOTE_NOT_FOUND)
    end

    private

    def config
      @config ||= YAML.load_file(CONFIG_FILE).transform_keys &:to_sym
    end
  end
end
