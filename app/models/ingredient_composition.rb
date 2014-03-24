class IngredientComposition < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :nutrient
  validates_presence_of :value, :nutrient_id
  validates_numericality_of :value, greater_than_or_equal_to: 0.0
  validates_uniqueness_of :nutrient_id, scope: :ingredient_id

  def nutrient_name
    nutrient.name
  end

  def nutrient_unit
    nutrient.unit
  end
  
end
