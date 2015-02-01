require 'rails_helper'

describe UserSearch do
  describe "#call" do
    it 'return users' do
      user1 = User.create(name: 'user1', age: 2)
      user2 = User.create(name: 'user2', age: 1)
      expect(UserSearch.new.call).to eq [user1, user2]
    end

    it 'sort the results' do
      user1 = User.create(name: 'user1', age: 2)
      user2 = User.create(name: 'user2', age: 1)
      sort_options = { predicate: :age }
      expect(UserSearch.new(sort: sort_options).call).to eq [user2, user1]

      sort_options = { predicate: :age, reverse: true }
      expect(UserSearch.new(sort: sort_options).call).to eq [user1, user2]
    end

    it 'do the pagination' do
      user1 = User.create(name: 'user1', age: 2)
      user2 = User.create(name: 'user2', age: 1)

      pagination_options = { start: 0, number: 1 }
      actual = UserSearch.new(pagination: pagination_options).call
      expect(actual).to eq [user1]

      pagination_options = { start: 1, number: 1 }
      actual = UserSearch.new(pagination: pagination_options).call
      expect(actual).to eq [user2]

      pagination_options = { start: 0, number: 2 }
      actual = UserSearch.new(pagination: pagination_options).call
      expect(actual).to eq [user1, user2]

      pagination_options = { start: 1, number: 2 }
      actual = UserSearch.new(pagination: pagination_options).call
      expect(actual).to eq [user2]
    end
  end
end
