class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.string :day, null: false
      t.integer :order, null: false
      t.integer :content_id, null: false
      t.references :content, foreign_key: true
      t.timestamps
    end
  end
end
