require 'sidekiq'

# redis_opts = {:url => 'redis://127.0.0.1:6379/1', :namespace => 'cms_queue'}
# # If fakeredis is loaded, use it explicitly
# redis_opts.merge!(:driver => Redis::Connection::Memory) if defined?(Redis::Connection::Memory)

# Sidekiq.configure_client do |config|
#   config.redis = redis_opts
# end

# Sidekiq.configure_server do |config|
#   config.redis = redis_opts
# end

Dir[File.join(File.dirname(__FILE__), '**', '*.rb')].each { |f| require f }