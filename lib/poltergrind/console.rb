require 'sidekiq'
require 'pry'
require 'poltergrind/console'

module Poltergrind
  class Console
    def start
      require 'examples/examples'
      Pry.config.prompt_name = 'Poltergrind'
      Pry.start
    end
  end
end
