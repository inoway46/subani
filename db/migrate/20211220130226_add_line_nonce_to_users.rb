class AddLineNonceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :line_nonce, :string
  end
end
