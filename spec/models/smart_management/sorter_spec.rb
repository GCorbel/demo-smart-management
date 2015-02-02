require 'rails_helper'

module SmartManagement
  describe Sorter do
    describe "#call" do
      it 'sort the results' do
        user1 = User.create(name: 'user1', age: 2)
        user2 = User.create(name: 'user2', age: 1)
        sort_options = { predicate: :age }
        expect(Sorter.new(User.all, sort_options).call).to eq [user2, user1]
      end

      it 'can do a reverse sort' do
        user1 = User.create(name: 'user1', age: 2)
        user2 = User.create(name: 'user2', age: 1)
        sort_options = { predicate: :age, reverse: true }
        expect(Sorter.new(User.all, sort_options).call).to eq [user1, user2]
      end
    end
  end
end
