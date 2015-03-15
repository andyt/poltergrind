# Poltergrind

A proof-of-concept gem to faciliate load testing using PhantomJS via Poltergeist and Capybara.

Concurrency is created using Sidekiq workers.


## Installation

Add this line to your application's Gemfile:

    gem 'poltergrind'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install poltergrind

## Usage

Include Poltergrind::Worker in a Sidekiq worker:

	require 'poltergrind/worker'

	class GoogleHomepageTest
	  include Poltergrind::Worker

	  def perform
	    time('google.home') do
	      visit 'https://google.com/'
	      expect(page).to have_content "I'm feeling lucky"
	      puts current_url
	    end
	  end
	end

Use foreman to start the dependencies (Redis, Sidekiq, a simple local Statsd server):

    bundle exec foreman start

Then enqueue the jobs:

	10.times { GoogleHomepageTest.perform_async }


## Contributing

1. Fork it ( https://github.com/[my-github-username]/poltergrind/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
