# Poltergrind

A gem for performance / concurrency testing applications using PhantomJS via Poltergeist and Capybara. 
Right now, it's really just a proof-of-concept waiting for a use case. It seemed like an interesting 
and viable architecture for such a framework.

Concurrency is created using Sidekiq workers. Capybara and Poltergeist aren't that happy in threads, so 
Sidekiq thread concurrency is set at 1 and multiple processes are used. Within the gem, in development, 
those are handled using Foreman.

The idea is that a Sidekiq worker's #perform method is wrapped with statsd metrics - timing, a gauge 
for start and finish, and a counter. This then allows the many and varied statsd monitoring and analysis 
tools to report on application performance. The multi-process model allows all cores to be used.

Poltergrind is aimed at a scaled deployment on a PAAS such as Heroku or Cloudfoundry, perhaps using 
something like http://challengepost.com/software/heroku-buildpack-phantomjs. Or perhaps more simply on one 
or more AWS EC2 instances.


## Installation

This is a functioning gem, but for now you're probably best cloning the repo or a fork and having a play.


## Usage

Use foreman to start the dependencies (Redis, 8 Sidekiq *processes*, a simple Statsd server and a test 
app racked up by Puma):

    bundle exec foreman start

To see it in action, start the console:

    ./bin/console

This will load the examples in lib. Then you can (enqueue) some tests:

	100.times { TestAppWorker.perform_async }

You'll see the statsd metrics in the foreman output, along the lines of:

	20:23:33 statsd.1        | StatsD Metric: poltergrind.TestAppWorker.perform.count 1|c
	20:23:33 statsd.1        | StatsD Metric: poltergrind.TestAppWorker.perform.start 1426710213|g
	20:23:33 statsd.1        | StatsD Metric: poltergrind.TestAppWorker.perform.duration 110|ms
	20:23:33 statsd.1        | StatsD Metric: poltergrind.TestAppWorker.perform.finish 1426710213|g

The reason for the gauge is to mark the start and the end of the entire test run. 

To create your own test worker, include Poltergrind::Worker in a Sidekiq worker:

	require 'poltergrind/worker'

	class GoogleHomepageTest
	  include Poltergrind::Worker

	  def perform
	    super do
	      time('google.homepage') do
	        visit 'https://google.com/'
	        puts current_url
	        expect(page).to have_css %Q|input[value="I'm Feeling Lucky"]|
	      end
	    end
	  end
	end

You can do what you like in here for your tests orchestrated by #perform: you can split it up into steps, nest calls to #time or any of the other methods delegated to statsd-ruby, and have some class methods (e.g. self.perform) that you 
can call to run repeatable tests more easily.

This hopefully gives a full-stack Javascript performance testing framework to simulate real users hitting your application, with the familiar DSL of Capybara and easily manageable concurrency.

There's no reason why this needs to use phantomjs. It could be extended to use anything that Capybara supports such as firefox or chromedriver, although phantomjs is possibly fastest and easiest to get going headless.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/poltergrind/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
