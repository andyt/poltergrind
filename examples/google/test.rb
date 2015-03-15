require 'poltergrind/worker'

class GoogleHomepageTest
  include Poltergrind::Worker

  def self.perform
    10.times { self.perform_async }
  end

  def perform
    time('google.home') do
      visit 'https://google.com/'
      expect(page).to have_content "I'm feeling lucky"
      puts current_url
    end
  end
end
