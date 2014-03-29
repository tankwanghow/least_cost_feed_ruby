class User < ActiveRecord::Base
  has_secure_password
  include SentientUser
  validates :username, uniqueness: true
  validates :name, :username, :time_zone, :currency, :weight_unit, :status, :email , presence: true
  has_many :ingredients
  has_many :nutrients
  has_many :formulas

  def self.find_users terms=nil, page=1
    if terms.blank?
      User.all.page(page).order(:name)
    else
      User.where("username || name || email || status ilike ?", "%#{terms}%").page(page).order(:name)
    end
  end
end
