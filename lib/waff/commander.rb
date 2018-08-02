module Waff
  class Commander
    class << self
      def call params
        LocalRepository.check_existence!
        Config.init_config!

        command = params.shift

        case command
        when 'take'
          Commands::Take.call(params)
        when 'pause'
          Commands::Pause.call(params)
        when 'list'
          Commands::List.call(params)
        when 'show'
          Commands::Show.call(params)
        when 'open'
          Commands::Open.call(params)
        else
          puts HELP_TEXT
        end
      end
    end
  end
end
