workers: bundle exec sidekiq -c 16 -r ./examples/examples.rb
statsd: ./bin/statsd
redis-server: redis-server
testapp: bundle exec puma --port 8999 testapp.ru