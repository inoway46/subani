class CreateLineNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :line_notifications do |t|
      t.references :master, foreign_key: true
      t.integer :month, null: false
      t.timestamps
    end
  end
end
