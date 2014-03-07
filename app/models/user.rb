require_relative '../../lib/searchable'

class User < ActiveRecord::Base
  has_secure_password
  include SentientUser
  include Searchable
  validates :username, uniqueness: true
  validates :name, :username, presence: true
  searchable content: [:name, :username, :email, :status]
  has_many :ingredients
end
