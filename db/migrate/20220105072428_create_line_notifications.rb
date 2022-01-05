class CreateLineNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :line_notifications do |t|
      t.integer :notifications_count, null: false, default: 0
      t.references :content, foreign_key: true

      t.timestamps
    end
  end
end
