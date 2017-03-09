require 'poltergrind/worker'

module Poltergrind
  describe Worker do
    let(:klass) do
      Class.new do
        def self.name; 'TestClass'; end
        include Poltergrind::Worker
      end
    end

    let(:instance) do
      klass.new
    end

    let(:statsd) do
      instance_spy('Statsd', increment: true, gauge: true)
    end

    before do
      allow(Poltergrind).to receive(:statsd).and_return(statsd)
    end

    it 'provides the Capybara DSL' do
      expect(instance).to respond_to :visit
    end

    it 'requests a statsd client with a namespace based on the worker class name' do
      expect(Poltergrind).to receive(:statsd).with(namespace: 'TestClass').and_return(statsd)

      instance.perform { nil }
    end

    it 'includes Sidekiq::Worker' do
      expect(klass).to respond_to :perform_async
    end

    it 'delegates statsd methods, excluding time' do
      %i(increment decrement timing gauge count).each do |method|
        expect(statsd).to receive(method)

        if method == :time
          instance.send(method, 'key'){ nil }
        elsif method =~ /^(in|de)crement$/
          instance.send(method, 'key')
        else
          instance.send(method, 'key', 1)
        end
      end
    end

    describe '#perform' do
      it 'times each session' do
        instance.perform { nil }

        expect(statsd).to have_received(:timing).with('perform.duration', anything)
      end

      it 'counts each job' do
        instance.perform { nil }

        expect(statsd).to have_received(:increment).with('perform.count.tests')
      end

      it 'counts each success' do
        instance.perform { nil }

        expect(statsd).to have_received(:increment).with('perform.count.success')
      end

      it 'calls #gauge for the start and end time of each job' do
        allow(Time).to receive(:now).and_return(Time.at(1426587858), Time.at(1426587859))

        instance.perform { nil }

        expect(statsd).to have_received(:gauge).with('perform.start', 1426587858)
        expect(statsd).to have_received(:gauge).with('perform.finish', 1426587859)
      end

      context 'on error' do
        it 'increments a failure counter and re-raises the error' do
          expect { instance.perform { raise 'An error' } }.to raise_error('An error')

          expect(statsd).to have_received(:increment).with('perform.count.errors')
          expect(statsd).to have_received(:increment).with('perform.count.tests')
        end
      end
    end
  end
end
