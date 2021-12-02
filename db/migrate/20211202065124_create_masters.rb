class CreateMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :masters do |t|
      t.string :title, null: false
      t.string :media, null: false
      t.text :url, null: false
      t.integer :stream, null: false, default: 0
      t.integer :rank

      t.timestamps
    end
  end
end
