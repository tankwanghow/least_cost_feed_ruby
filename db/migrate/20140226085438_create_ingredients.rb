class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.belongs_to :user_id
      t.string    :name
      t.decimal   :cost
    end
  end
end
