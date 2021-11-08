class CreateContents < ActiveRecord::Migration[5.2]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.string :media, null: false
      t.text :url, null: false

      t.timestamps
    end
  end
end
