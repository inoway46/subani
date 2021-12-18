class AddLineFlagToContents < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :line_flag, :boolean, default: false, null: false
  end
end
