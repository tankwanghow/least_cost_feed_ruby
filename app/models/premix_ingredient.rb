class PremixIngredient < ActiveRecord::Base
  belongs_to :premix, :foreign_key => "formula_id"
  belongs_to :ingredient

  def ingredient_name
    ingredient ? ingredient.name : nil
  end

end
