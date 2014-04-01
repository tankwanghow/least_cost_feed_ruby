class FormulaNutrient < ActiveRecord::Base

  belongs_to :formula
  belongs_to :nutrient
  validates_uniqueness_of :nutrient_id, scope: :formula_id
  validates_presence_of :nutrient_id
  validates_numericality_of :actual, greater_than_or_equal_to: 0.0

  def nutrient_name_unit
    nutrient ? "#{nutrient.name}(#{nutrient.unit})" : nil
  end

end
