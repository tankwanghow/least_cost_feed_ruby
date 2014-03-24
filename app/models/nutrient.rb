class Nutrient < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :unit, :user, :category
  validates_uniqueness_of :name
  has_many :ingredient_compositions, dependent: :destroy
  after_create :add_self_to_current_user_ingredient_compositons
    
  def self.find_nutrients terms=nil, page=1
    if terms.blank?
      User.current.nutrients.page(page).order(:name)
    else
      User.current.nutrients.where("name || unit || category ilike ?", "%#{terms}%").order(:name).page(page)
    end
  end

  private

  def add_self_to_current_user_ingredient_compositons
    user.ingredients.each do |i|
      i.ingredient_compositions.build(nutrient: self)
      i.save
    end
  end

end
