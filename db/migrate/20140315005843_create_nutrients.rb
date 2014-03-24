class CreateNutrients < ActiveRecord::Migration
  def change
    create_table :nutrients do |t|
      t.belongs_to :user,  null: false
      t.string     :name,  null: false
      t.string     :unit,  null: false
      t.text       :note
      t.string     :category, default: 'private', null: false
      t.integer    :lock_version, null: false, default: 0
      t.timestamps
    end
    add_index :nutrients, [:user_id, :name], unique: true
  end
end
