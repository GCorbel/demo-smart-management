class User < ActiveRecord::Base
  validates :name, :age, presence: true
end
