require 'poltergrind/worker'

class TestAppWorker
  include Poltergrind::Worker

  def perform
    super do
      visit 'http://localhost:8999/'
      puts current_url
      expect(page).to have_text 'slow'
    end
  end
end
