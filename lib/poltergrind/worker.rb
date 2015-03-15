require 'capybara/dsl'
require 'sidekiq'
require 'statsd'
require 'rspec'
require 'poltergrind/capybara'

module Poltergrind
  module Worker
    def self.included(base)
      base.include Capybara::DSL
      base.include Sidekiq::Worker
      base.include RSpec::Matchers

      base.instance_eval do
        sidekiq_options retry: false, dead: false
      end
    end

    def self.statsd
      @statsd ||= Statsd.new('localhost').tap { |sd| sd.namespace = 'poltergrind' }
    end

    def time(key)
      statsd.time(key) do
        yield
      end
    end

    def statsd
      Poltergrind::Worker.statsd
    end

    def perform
      Capybara.using_session 'poltergrind' do
        yield
      end
    end
  end
end
