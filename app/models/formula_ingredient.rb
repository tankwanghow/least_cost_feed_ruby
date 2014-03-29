class FormulaIngredient < ActiveRecord::Base
  belongs_to :formula
  belongs_to :ingredient
  validates_uniqueness_of :ingredient_id, scope: :formula_id
  validates_presence_of :ingredient_id
  validates_numericality_of :max, greater_than_or_equal_to: 0.0
  validates_numericality_of :min, greater_than_or_equal_to: 0.0
  validates_numericality_of :actual, greater_than_or_equal_to: 0.0
  validates_numericality_of :shadow, greater_than_or_equal_to: 0.0

  def ingredient_name
    ingredient ? ingredient.name : nil
  end

  def ingredient_cost
    ingredient ? ingredient.cost : 0.0
  end

  def ingredient_cost= value
    ingredient.cost = value
  end

  def weight
    bz = formula.try(:batch_size)
    a = ingredient.try(:actual)
    bz && a ? bz * a : 0
  end
end
