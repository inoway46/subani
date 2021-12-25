class AddColumnMasters < ActiveRecord::Migration[5.2]
  def up
    add_column :masters, :season, :string
  end

  def down
    remove_column :masters, :season, :string
  end
end
