class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.string :day
      t.time :time
      t.integer :content_id
      t.references :content, foreign_key: true
      t.timestamps
    end
  end
end
