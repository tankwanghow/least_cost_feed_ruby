class CreateFormulaNutrients < ActiveRecord::Migration
  def change
    create_table :formula_nutrients do |t|
      t.belongs_to :formula, null: false
      t.belongs_to :nutrient, null: false
      t.decimal :max, null: false, default: 0, precision: 12, scale: 4
      t.decimal :min, null: false, default: 0, precision: 12, scale: 4
      t.decimal :actual, null: false, default: 0, precision: 12, scale: 4
    end
    add_index :formula_nutrients, [:nutrient_id, :formula_id], unique: true
  end
end
