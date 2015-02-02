require 'rails_helper'

module SmartManagement
  describe Paginer do
    describe "#call" do
      it 'do the pagination' do
        user1 = User.create(name: 'user1', age: 2)
        user2 = User.create(name: 'user2', age: 1)

        pagination_options = { start: 0, number: 1 }
        actual = Paginer.new(User.all, pagination_options).call
        expect(actual).to eq [user1]

        pagination_options = { start: 1, number: 1 }
        actual = Paginer.new(User.all, pagination_options).call
        expect(actual).to eq [user2]

        pagination_options = { start: 0, number: 2 }
        actual = Paginer.new(User.all, pagination_options).call
        expect(actual).to eq [user1, user2]

        pagination_options = { start: 1, number: 2 }
        actual = Paginer.new(User.all, pagination_options).call
        expect(actual).to eq [user2]
      end
    end
  end
end
