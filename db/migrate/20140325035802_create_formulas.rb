class CreateFormulas < ActiveRecord::Migration[4.2]
  def change
    create_table :formulas do |t|
      t.belongs_to :user, null: false
      t.string     :name, null: false
      t.decimal    :batch_size, null: false, default: 0, precision: 12, scale: 4
      t.decimal    :cost, null: false, default: 0, precision: 12, scale: 4
      t.text       :note
      t.integer    :lock_version, null: false, default: 0
      t.timestamps
    end
    add_index :formulas, [:user_id, :name], unique: true
  end
end
