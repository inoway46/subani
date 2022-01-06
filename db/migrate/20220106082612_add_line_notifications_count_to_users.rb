class AddLineNotificationsCountToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :line_notifications_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :users, :line_notifications_count
  end
end
