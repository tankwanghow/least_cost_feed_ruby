class User < ActiveRecord::Base
  has_secure_password
  include SentientUser
  validates :username, uniqueness: true
  validates :name, :username, presence: true
  has_many :ingredients
end
