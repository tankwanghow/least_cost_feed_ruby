class User < ActiveRecord::Base
  has_secure_password
  include SentientUser
  validates :username, uniqueness: true
  validates :name, :username, presence: true
  has_many :ingredients

  def self.find_users terms=nil, page=1
    if terms.blank?
      User.all.page(page).order(:name)
    else
      User.where("username || name || email || status ilike ?", "%#{terms}%").page(page).order(:name)
    end
  end
end
