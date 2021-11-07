class CreateContents < ActiveRecord::Migration[5.2]
  def change
    create_table :contents do |t|
      t.string :title
      t.string :media
      t.text :url

      t.timestamps
    end
  end
end
