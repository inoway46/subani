class AddUserIdToContents < ActiveRecord::Migration[5.2]
  def change
    add_reference :contents, :user, foreign_key: true
  end
end
