require 'capybara/dsl'
require 'sidekiq'
require 'statsd'
require 'rspec'
require 'forwardable'

require 'poltergrind/capybara'

module Poltergrind
  module Worker
    extend Forwardable

    def_delegators :statsd, :time, :increment, :decrement, :timing, :gauge, :count

    def self.included(base)
      base.include Capybara::DSL
      base.include Sidekiq::Worker
      base.include RSpec::Matchers

      base.instance_eval do
        sidekiq_options retry: false, dead: false

        def self.namespace
          "poltergrind.#{name}"
        end

        def self.statsd
          @statsd ||= Statsd.new('localhost').tap { |sd| sd.namespace = namespace }
        end
      end
    end

    def statsd
      self.class.statsd
    end

    def session_name
      "poltergrind-#{Thread.current.object_id}"
    end

    def perform
      Capybara.using_session(session_name) do
        increment 'perform.count'
        gauge 'perform.start', Time.now.to_i

        time 'perform.duration' do
          yield
        end

        gauge 'perform.finish', Time.now.to_i
      end
    end
  end
end
