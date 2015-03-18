require 'poltergrind/worker'

class GoogleHomepageWorker
  include Poltergrind::Worker

  def self.perform
    10.times { self.perform_async }
  end

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
