class CreateFormulaIngredientsHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :formula_ingredients_histories do |t|
      t.belongs_to :formula, null: false
      t.belongs_to :ingredient, null: false
      t.decimal :actual, null: false, default: 0, precision: 12, scale: 6
      t.boolean :use, default: true, null: false
      t.string  :logged_at, null: false
    end
    add_index :formula_ingredients_histories, [:ingredient_id, :formula_id, :logged_at], unique: true, name: 'by_ing_id_for_id_log_at'
  end
end
