class AddMasterIdsToContents < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :master_id, :integer
  end
end
