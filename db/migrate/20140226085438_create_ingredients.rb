class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.belongs_to :user, null: false
      t.string     :name, null: false
      t.decimal    :cost, null: false, default: 0, precision: 12, scale: 4
      t.string     :batch_no
      t.text       :note
      t.string     :status, null: false, default: 'using'
      t.string     :category, default: 'private', null: false
      t.integer    :lock_version, null: false, default: 0
      t.timestamps
    end
    add_index :ingredients, [:user_id, :name, :batch_no], unique: true
  end
end
