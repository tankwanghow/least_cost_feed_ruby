class ChangeDatabaseTable < ActiveRecord::Migration[4.2]

  def up
    remove_column :premix_ingredients, :created_at
    remove_column :premix_ingredients, :updated_at

    change_table :premix_ingredients do |t|
      t.change :actual_usage, :float
      t.change :premix_usage, :float
    end

    change_table :formula_nutrients do |t|
      t.change :max,    :float
      t.change :min,    :float
      t.change :actual, :float
    end

    change_table :formula_ingredients do |t|
      t.change :max,    :float
      t.change :min,    :float
      t.change :actual, :float
      t.change :weight, :float
      t.change :shadow, :float
    end

    change_table :ingredient_compositions do |t|
      t.change :value, :float
    end

    change_table :ingredients do |t|
      t.change :package_weight, :float
      t.change :cost, :float
    end

    change_table :formulas do |t|
      t.change :batch_size, :float
      t.change :target_bag_weight, :float
      t.change :cost, :float
    end

    change_table :formulas do |t|
      t.change :batch_size, :float
      t.change :target_bag_weight, :float
      t.change :cost, :float
    end

  end

  def down
    add_column :premix_ingredients, :created_at, :datetime
    add_column :premix_ingredients, :updated_at, :datetime
  end
end
