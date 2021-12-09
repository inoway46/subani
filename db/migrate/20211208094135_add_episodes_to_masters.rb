class AddEpisodesToMasters < ActiveRecord::Migration[5.2]
  def change
    add_column :masters, :episode, :integer, default: 0
  end
end
