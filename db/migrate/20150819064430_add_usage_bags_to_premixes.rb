class AddUsageBagsToPremixes < ActiveRecord::Migration[4.2]
  def change
    add_column :formulas, :usage_bags, :integer, defalut: 1
  end
end
