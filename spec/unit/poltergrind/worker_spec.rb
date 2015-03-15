require 'poltergrind/worker'

module Poltergrind
  describe Worker do
    let(:klass) do
      Class.new do
        include Poltergrind::Worker
      end
    end

    let(:instance) do
      klass.new
    end

    it 'provides the Capybara DSL' do
      expect(instance).to respond_to :visit
    end

    it 'provides #time' do
      expect(instance).to respond_to :time
    end

    it 'includes Sidekiq::Worker' do
      expect(klass).to respond_to :perform_async
    end

    it 'provides a Statsd client' do
      expect(instance.statsd).to be_a Statsd
    end
  end
end
