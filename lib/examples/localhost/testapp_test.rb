require 'poltergrind/worker'

class TestappTest
  include Poltergrind::Worker

  def perform
    time('testapp.load') do
      visit 'http://localhost:8999/'
      puts current_url
      expect(page).to have_text 'slow'
    end
  end
end
