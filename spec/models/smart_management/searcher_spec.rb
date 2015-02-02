require 'rails_helper'

module SmartManagement
  describe Searcher do
    describe "#call" do
      it 'do the search' do
        user1 = User.create(name: 'user1', age: 2)
        User.create(name: 'Guirec', age: 1)

        search_options = { name: 'user' }
        actual =  Searcher.new(User.all, search_options).call
        expect(actual).to eq [user1]
      end
    end
  end
end
