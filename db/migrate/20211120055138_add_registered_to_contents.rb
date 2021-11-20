class AddRegisteredToContents < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :registered, :boolean, default: false, null: false
  end
end
