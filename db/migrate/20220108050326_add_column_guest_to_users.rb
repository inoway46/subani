class AddColumnGuestToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :guest, :boolean, default: false, null: false
  end

  def down
    remove_column :users, :guest, :boolean
  end
end
