require 'poltergrind/version'
require 'poltergrind/worker'

module Poltergrind
  class << self
    def statsd(namespace: nil)
      namespaces = [statsd_namespace, namespace].compact.join('.')

      Statsd.new(statsd_host).tap { |sd| sd.namespace = namespaces }
    end

    private

    def statsd_namespace
      from_env = ENV['POLTERGRIND_STATSD_NAMESPACE'].to_s.gsub(/[^a-zA-Z0-9\-\.]/, '_')

      from_env == '' ? 'poltergrind' : from_env
    end

    def statsd_host
      ENV['POLTERGRIND_STATSD_HOST'] || 'localhost'
    end
  end
end
