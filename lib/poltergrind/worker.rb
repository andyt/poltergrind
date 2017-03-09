require 'capybara/dsl'
require 'sidekiq'
require 'statsd'
require 'rspec'
require 'forwardable'

require 'poltergrind/capybara'

module Poltergrind
  module Worker
    extend Forwardable

    def_delegators :statsd, :increment, :decrement, :timing, :gauge, :count

    def self.included(base)
      base.include Capybara::DSL
      base.include Sidekiq::Worker
      base.include RSpec::Matchers

      base.instance_eval do
        sidekiq_options retry: false, dead: false

        def self.statsd
          @statsd ||= Poltergrind.statsd(namespace: name.gsub('::', '.'))
        end
      end
    end

    def perform
      increment 'perform.count.tests'
      gauge 'perform.start', Time.now.to_i

      with_capybara_session do
        yield
      end

      gauge 'perform.finish', Time.now.to_i
      increment 'perform.count.success'
    rescue Exception => _
      increment 'perform.count.errors'

      raise
    end

    private

    def with_capybara_session
      start = Time.now.to_f

      session_name = "poltergrind-#{Thread.current.object_id}"

      Capybara.using_session(session_name) do
        yield
      end

      statsd.timing('perform.duration', Time.now.to_f - start)
    end

    def statsd
      self.class.statsd
    end
  end
end
