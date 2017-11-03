class FormulaIngredientsHistory < ApplicationRecord
  belongs_to :formula
  belongs_to :ingredient
  validates_uniqueness_of :ingredient_id, scope: [:formula_id, :logged_at]
  validates_presence_of :ingredient_id
  validates_presence_of :logged_at
  validates_numericality_of :actual, greater_than_or_equal_to: 0.0, allow_nil: true
end
