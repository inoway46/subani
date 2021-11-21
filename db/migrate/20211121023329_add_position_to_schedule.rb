class AddPositionToSchedule < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :position, :integer
  end
end
