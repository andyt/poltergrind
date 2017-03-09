require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  options = {
      js_errors: true,
      timeout: 120,
      debug: ENV['DEBUG'] == '1',
      phantomjs_options: %w{--load-images=no --disk-cache=false --ignore-ssl-errors=true --local-to-remote-url-access=true --web-security=false},
      inspector: true, # use page.driver.debug
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.default_driver = :poltergeist
