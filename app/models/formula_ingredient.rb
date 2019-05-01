class FormulaIngredient < ActiveRecord::Base
  belongs_to :formula
  belongs_to :ingredient
  validates_uniqueness_of :ingredient_id, scope: :formula_id
  validates_presence_of :ingredient_id
  validates_numericality_of :actual, greater_than_or_equal_to: 0.0, allow_nil: true
  validates_numericality_of :shadow, greater_than_or_equal_to: 0.0, allow_nil: true

  def min_perc
    perc :min
  end

  def min_perc=value
    set_perc :min, value
  end

  def max_perc
    perc :max
  end

  def max_perc=value
    set_perc :max, value
  end

  def actual_perc
    perc :actual
  end

  def actual_perc=value
    set_perc :actual, value
  end

  def ingredient_name
    ingredient ? ingredient.name : nil
  end

  def ingredient_cost
    ingredient ? ingredient.cost : 0.0
  end

  def ingredient_cost= value
    if ingredient.cost - value.to_d != 0
      ingredient.cost = value.to_d
      ingredient.save
    end
  end

  def shadow_price
    if shadow > 0
      ingredient ? ingredient.cost - shadow : 0
    else
      0
    end
  end

private

  def perc attr
    send(attr) ? send(attr) * 100 : nil
  end

  def set_perc attr, value
    if !value.blank?
      send("#{attr}=", value.to_d / 100)
    else
      send("#{attr}=", nil)
    end
  end

end
