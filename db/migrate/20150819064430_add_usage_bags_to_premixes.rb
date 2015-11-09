class AddUsageBagsToPremixes < ActiveRecord::Migration
  def change
    add_column :formulas, :usage_bags, :integer, defalut: 1
  end
end
