class AddLineNotificationsCountToContents < ActiveRecord::Migration[5.2]
  def self.up
    add_column :contents, :line_notifications_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :contents, :line_notifications_count
  end
end
