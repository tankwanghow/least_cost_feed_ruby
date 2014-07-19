class Ingredient < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :cost, :status, :category
  validates_uniqueness_of :name, scope: :user_id
  validates_numericality_of :cost, greater_than_or_equal_to: 0
  validates_numericality_of :package_weight, greater_than_or_equal_to: 0, allow_nil: true
  has_many :ingredient_compositions, -> { includes(:nutrient).order("nutrients.name") }, dependent: :destroy

  accepts_nested_attributes_for :ingredient_compositions, allow_destroy: true

  def self.find_ingredients terms=nil, page=1
    if terms.blank?
      User.current.ingredients.page(page).order(:name)
    else
      User.current.ingredients.where("name || status || category ilike ?", "%#{terms}%").order(:name).page(page)
    end
  end

  def self.create_like id
    like = find id
    a = like.dup
    a.name = like.name + " Copy #{DateTime.now.in_time_zone(User.current.time_zone).strftime('%Y%m%d%H%M%S')}"
    like.ingredient_compositions.each do |t|
      a.ingredient_compositions.build nutrient: t.nutrient, value: t.value
    end
    a.save!
    a
  end

end
