class AddUpdateDayColumnMasters < ActiveRecord::Migration[5.2]
  def up
    add_column :masters, :update_day, :string
  end

  def down
    remove_column :masters, :update_day, :string
  end
end
