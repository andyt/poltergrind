require 'sidekiq'
require 'pry'
require 'poltergrind/console'

module Poltergrind
  class Console
    def start
      require File.expand_path('../../../examples/examples.rb', __FILE__)
      binding.pry
    end
  end
end
