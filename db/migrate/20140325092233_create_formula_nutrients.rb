class CreateFormulaNutrients < ActiveRecord::Migration
  def change
    create_table :formula_nutrients do |t|
      t.belongs_to :formula, null: false
      t.belongs_to :nutrient, null: false
      t.decimal :max, precision: 12, scale: 6
      t.decimal :min, precision: 12, scale: 6
      t.decimal :actual, null: false, default: 0, precision: 12, scale: 6
      t.boolean :use, default: true, null: false
    end
    add_index :formula_nutrients, [:nutrient_id, :formula_id], unique: true
  end
end
