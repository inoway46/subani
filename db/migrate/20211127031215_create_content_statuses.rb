class CreateContentStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :content_statuses do |t|
      t.references :user, foreign_key: true
      t.references :content, foreign_key: true

      t.timestamps
    end
  end
end
