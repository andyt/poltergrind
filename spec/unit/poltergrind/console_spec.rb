require 'poltergrind/console'

module Poltergrind
  describe Console do
    describe  '#start' do
      it 'responds' do
        expect(Console.new).to respond_to :start
      end
    end
  end
end
