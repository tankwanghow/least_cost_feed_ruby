class User < ActiveRecord::Base
  has_secure_password
  include SentientUser
  validates :username, uniqueness: true
  validates :name, :username, presence: true
  has_many :ingredients

  def self.find_users terms=nil, page=1, per=25
    if terms.blank?
      @user = User.all.page(page).per(per).order(:name)
    else
      @users = User.where("username || name || email || status ilike ?", "%#{terms}%").page(page).per(per).order(:name)
    end
  end
end
