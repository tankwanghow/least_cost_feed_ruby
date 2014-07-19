class CreatePremixIngredients < ActiveRecord::Migration
  def change
    create_table :premix_ingredients do |t|
	    t.belongs_to :formula, null: false
      t.belongs_to :ingredient, null: false
      t.decimal :actual_usage, precision: 12, scale: 6
      t.integer :premix_usage, precision: 12, scale: 6, default: 0
      t.timestamps
    end
    add_index :premix_ingredients, [:ingredient_id, :formula_id], unique: true
  end
end
