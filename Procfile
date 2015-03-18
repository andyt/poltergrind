redis-server: redis-server
worker: bundle exec sidekiq -c 1 -r ./lib/examples/examples.rb
statsd: ./bin/statsd
web-test: bundle exec puma --port 8999 test_app.ru