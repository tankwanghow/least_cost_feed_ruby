class Premix < Formula
  self.table_name  = "formulas"

  has_many :premix_ingredients, :foreign_key => "formula_id"

  accepts_nested_attributes_for :premix_ingredients

  def total_premix_weight
    self.premix_weight * self.bags_of_premix
  end

  def balance_bag_weight
    (self.target_bag_weight/self.usage_bags) - self.premix_weight
  end

  def set_premix_ingredients
    premix_ingredients.destroy_all
    formula_ingredients.each do |t|
      if (t.actual * self.batch_size) > 0
        w = ((t.actual * self.batch_size) <= 5.0 ? (t.actual * self.batch_size) : 0)
        premix_ingredients.create(ingredient_id: t.ingredient_id, actual_usage: (t.actual * self.batch_size), premix_usage: w)
      end
    end
  end

  def premix_weight
    premix_ingredients.sum(:premix_usage)
  end

end
