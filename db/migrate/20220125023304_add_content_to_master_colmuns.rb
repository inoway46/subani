class AddContentToMasterColmuns < ActiveRecord::Migration[5.2]
  def up
    add_column :contents, :season, :string
    add_column :contents, :dummy_episode, :integer, default: 0
    add_column :contents, :update_day, :string
  end

  def down
    remove_column :contents, :season, :string
    remove_column :contents, :dummy_episode, :integer, default: 0
    remove_column :contents, :update_day, :string
  end
end
