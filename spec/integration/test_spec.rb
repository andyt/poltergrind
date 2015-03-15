require 'sidekiq/testing'
require 'poltergrind/worker'

Sidekiq::Testing.inline!

module Poltergrind
  describe Worker do
    class ExampleTest
      include Poltergrind::Worker

      def self.perform
        10.times { perform_async }
      end

      def perform
        time('example-test') do
          visit 'http://google.com/'
          expect(page).to have_content 'Google'
          puts current_url
        end
      end
    end

    it 'sends stats to a statsd server' do
      expect_any_instance_of(Statsd).to receive(:time).exactly(10).times.and_call_original

      ExampleTest.perform
    end
  end
end

