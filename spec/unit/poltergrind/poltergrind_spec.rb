require 'spec_helper'

require 'poltergrind'

describe Poltergrind do
  describe '.statsd' do
    let(:statsd) { Poltergrind.statsd }

    it 'provides a Statsd client' do
      expect(statsd).to be_a Statsd
    end

    it 'has a default namespace of poltergrind' do
      expect(statsd.namespace).to eq 'poltergrind'
    end

    it 'uses an underscored namespace from the environment' do
      stub_const('ENV', 'POLTERGRIND_STATSD_NAMESPACE' => 'a weird/namespace-yeah.namespace')

      expect(statsd.namespace).to eq 'a_weird_namespace-yeah.namespace'
    end

    it 'has a default hostname of localhost' do
      expect(statsd.host).to eq 'localhost'
    end

    it 'uses a host from the environment' do
      stub_const('ENV', 'POLTERGRIND_STATSD_HOST' => '10.0.0.1')

      expect(statsd.host).to eq '10.0.0.1'
    end

    it 'allows a sub-namespace' do
      statsd = Poltergrind.statsd(namespace: 'WorkerClassName')

      expect(statsd.namespace).to eq 'poltergrind.WorkerClassName'
    end
  end
end
