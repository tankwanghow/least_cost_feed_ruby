class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string     :username,           null: false
      t.string     :email
      t.string     :name
      t.string     :password_digest,    null: false
      t.string     :status,          default: 'pending', null: false
      t.boolean    :is_admin,        default: false, null: false
      t.string     :country,         default: 'Malaysia', null: false
      t.string     :time_zone,       default: 'Kuala Lumpur', null: false
      t.string     :weight_unit,     default: 'KG', null: false
      t.integer    :lock_version,    default: 0, null: false
      t.timestamps
     end

     add_index :users, :username, unique: true
  end
end
