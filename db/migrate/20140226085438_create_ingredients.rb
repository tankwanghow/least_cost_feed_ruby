class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.belongs_to :user, null: false
      t.string     :name,  null: false
      t.decimal    :cost,  null: false, default: 0, precision: 12, scale: 4
      t.integer    :lock_version, null: false, default: 0
      t.timestamps
    end
    add_index :ingredients, [:user_id, :name], unique: true
  end
end
