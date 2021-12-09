class AddEpisodesToContents < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :episode, :integer, default: 0
  end
end
