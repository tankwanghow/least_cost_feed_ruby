class FormulaIngredient < ActiveRecord::Base
  belongs_to :formula
  belongs_to :ingredient
  validates_uniqueness_of :ingredient_id, scope: :formula_id
  validates_presence_of :ingredient_id
  validates_numericality_of :actual, greater_than_or_equal_to: 0.0, allow_nil: true
  validates_numericality_of :shadow, greater_than_or_equal_to: 0.0, allow_nil: true

  after_save :save_ingredient_cost

  def min_perc
    min ? min * 100 : nil
  end

  def min_perc=value
    if !value.blank?
      self.min = value.to_d / 100
    else
      self.min = nil
    end
  end

  def max_perc
    max ? max * 100 : nil
  end

  def max_perc=value
    if !value.blank?
      self.max = value.to_d / 100
    else
      self.max = nil
    end
  end

  def actual_perc
    actual ? actual * 100 : nil
  end

  def actual_perc=value
    if !value.blank?
      self.actual = value.to_d / 100
    else
      self.actual = nil
    end
  end

  def ingredient_name
    ingredient ? ingredient.name : nil
  end

  def ingredient_cost
    ingredient ? ingredient.cost : 0.0
  end

  def ingredient_cost= value
    ingredient.cost = value
  end

private

  def save_ingredient_cost
    ingredient.save if ingredient.changed?
  end

end
