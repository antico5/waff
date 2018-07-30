require 'fileutils'
require 'httparty'

Dir[File.join(__dir__, 'waff', '**/*.rb')].each { |file| require file }

module Waff
  CONFIG_FILE = '.waff.yml'
  EXCLUDE_FILE = '.git/info/exclude'

  HELP_TEXT = <<-EOF
Waff version #{Waff::VERSION}

Usage:

waff [command] [params]

Commands:

waff list         -- Shows ready and in progress issues
waff show         -- Shows description of current issue (determined by current branch)
waff show number  -- Shows description of a given issue
waff take number  -- Sets the issue in progress, assigns it to yourself, and creates a branch for it
waff pause number -- Sets the issue to ready state
  EOF

end
