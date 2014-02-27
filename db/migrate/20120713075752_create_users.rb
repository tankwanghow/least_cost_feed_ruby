class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string     :username,           null: false
      t.string     :email
      t.string     :name
      t.string     :password_digest,    null: false
      t.string     :status,          default: 'pending'
      t.integer    :lock_version,    default: 0
     end

     add_index :users, :username, unique: true
  end
end
