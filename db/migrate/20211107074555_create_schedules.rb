class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.string :day, null: false
      t.integer :order, null: false
      t.belongs_to :content
      t.timestamps
    end
  end
end
