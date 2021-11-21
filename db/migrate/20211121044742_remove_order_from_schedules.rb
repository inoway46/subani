class RemoveOrderFromSchedules < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedules, :order, :integer
  end
end
