class CreateIngredients < ActiveRecord::Migration[4.2]
  def change
    create_table :ingredients do |t|
      t.belongs_to :user, null: false
      t.string     :name, null: false
      t.decimal    :package_weight, default: 0.1, precision: 12, scale: 4
      t.decimal    :cost, null: false, default: 0, precision: 12, scale: 4
      t.string     :status, null: false, default: 'using'
      t.string     :category, default: 'private', null: false
      t.text       :note
      t.integer    :lock_version, null: false, default: 0
      t.timestamps
    end
    add_index :ingredients, [:user_id, :name], unique: true
  end
end
