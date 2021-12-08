class AddEpisodesToContents < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :episode, :integer
  end
end
