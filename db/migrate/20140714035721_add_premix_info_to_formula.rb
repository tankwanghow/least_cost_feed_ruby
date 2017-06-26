class AddPremixInfoToFormula < ActiveRecord::Migration[4.2]
  def change
  	add_column :formulas, :target_bag_weight, :decimal, precision: 12, scale: 6, defalut: 1
  	add_column :formulas, :bags_of_premix, :integer, defalut: 1
  end
end
