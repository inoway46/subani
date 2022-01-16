class AddDummyEpisodeToMasters < ActiveRecord::Migration[5.2]
  def up
    add_column :masters, :dummy_episode, :integer, default: 0
  end

  def down
    remove_column :masters, :dummy_episode, :integer, default: 0
  end
end
