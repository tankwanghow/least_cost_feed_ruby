class CreateIngredientCompositions < ActiveRecord::Migration
  def change
    create_table :ingredient_compositions do |t|
      t.belongs_to :ingredient, null: false
      t.belongs_to :nutrient,   null: false
      t.decimal :value, null: false, default: 0, precision: 14, scale: 6
    end
    add_index :ingredient_compositions, [:ingredient_id, :nutrient_id], unique: true
  end
end
