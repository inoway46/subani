class RemoveUserIdFromContent < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :contents, :user
    remove_reference :contents, :user, index: true
  end
end
