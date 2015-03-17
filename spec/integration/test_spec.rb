require 'sidekiq/testing'
Sidekiq::Testing.inline!

require 'poltergrind/worker'
require 'examples/localhost/testapp_test'

module Poltergrind
  describe Worker do
    it 'sends stats to a statsd server' do
      expect_any_instance_of(Statsd).to receive(:time).exactly(5).times.and_call_original

      5.times { TestappTest.perform_async }
    end
  end
end

