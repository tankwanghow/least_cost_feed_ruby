class AddUsageToFormulas < ActiveRecord::Migration[4.2]
  def change
    add_column :formulas, :usage_per_day, :integer, default: 0
  end
end
