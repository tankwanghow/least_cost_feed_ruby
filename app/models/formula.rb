class Formula < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :name, :batch_size, :cost
  validates_numericality_of :batch_size, greater_than_or_equal_to: 0.0
  validates_numericality_of :cost, greater_than_or_equal_to: 0.0
  validates_uniqueness_of :name, scope: :user_id

  has_many :formula_ingredients, -> { includes(:ingredient).order("ingredients.name") }, dependent: :destroy
  has_many :formula_nutrients, -> { includes(:nutrient).order("nutrients.name") }, dependent: :destroy

  accepts_nested_attributes_for :formula_ingredients, allow_destroy: true
  accepts_nested_attributes_for :formula_nutrients, allow_destroy: true

  def self.find_formulas terms=nil, page=1
    if terms.blank?
      User.current.formulas.page(page).order(:name)
    else
      User.current.formulas.where("name ilike ?", "%#{terms}%").order(:name).page(page)
    end
  end
end
