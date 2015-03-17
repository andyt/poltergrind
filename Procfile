redis-server: redis-server
worker: bundle exec sidekiq -c 1 -r ./lib/examples/examples.rb
statsd: ./bin/statsd
testapp: bundle exec puma --port 8999 testapp.ru