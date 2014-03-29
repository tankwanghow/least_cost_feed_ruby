class IngredientComposition < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :nutrient
  validates_presence_of :value, :nutrient_id
  validates_numericality_of :value, greater_than_or_equal_to: 0.0
  validates_uniqueness_of :nutrient_id, scope: :ingredient_id
  
  after_update do
    ingredient.touch
  end

  def nutrient_name_unit
    nutrient ? "#{nutrient.name}(#{nutrient.unit})" : nil
  end
  
end
