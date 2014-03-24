class Ingredient < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :cost, :status, :category
  validates_uniqueness_of :name, scope: [:user_id, :batch_no]
  validates_numericality_of :cost, greater_than_or_equal_to: 0
  has_many :ingredient_compositions, -> { includes(:nutrient).order("nutrients.name") }, dependent: :destroy
  accepts_nested_attributes_for :ingredient_compositions

  def self.new_with_ingredient_compositions
    k = self.new
    User.current.nutrients.each do |n|
      k.ingredient_compositions.build(nutrient: n)
    end 
    k
  end

  def self.find_ingredients terms=nil, page=1
    if terms.blank?
      User.current.ingredients.page(page).order(:name, :batch_no)
    else
      User.current.ingredients.where("name || batch_no || status || category ilike ?", "%#{terms}%").order(:name, :batch_no).page(page)
    end
  end

end
