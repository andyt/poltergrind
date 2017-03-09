require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

require 'poltergrind/worker'
require 'examples/localhost/test_app_worker'

module Poltergrind
  describe Worker do
    let(:statsd) do
      instance_spy('Statsd', increment: true, gauge: true, timing: true)
    end

    before do
      allow(Statsd).to receive(:new).and_return(statsd)
    end

    context 'for failures' do
      it 'sends test and error counts to Statsd' do
        5.times do
          expect { TestAppWorker.perform_async }.to raise_error(Capybara::Poltergeist::StatusFailError)
        end

        expect(statsd).to have_received(:increment)
          .with('perform.count.tests').exactly(5).times

        expect(statsd).to have_received(:increment)
          .with('perform.count.errors').exactly(5).times
      end
    end
  end
end
