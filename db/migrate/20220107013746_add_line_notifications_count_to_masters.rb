class AddLineNotificationsCountToMasters < ActiveRecord::Migration[5.2]
  def self.up
    add_column :masters, :line_notifications_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :masters, :line_notifications_count
  end
end
