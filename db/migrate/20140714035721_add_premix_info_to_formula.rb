class AddPremixInfoToFormula < ActiveRecord::Migration
  def change
  	add_column :formulas, :target_bag_weight, precision: 12, scale: 6, defalut: 0
  	add_column :formulas, :bags_of_premix, :integer, defalut: 0
  end
end
