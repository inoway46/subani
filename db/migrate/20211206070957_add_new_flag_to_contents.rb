class AddNewFlagToContents < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :new_flag, :boolean, default: false, null: false
  end
end
