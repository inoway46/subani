class ChangeContentStatusesToUserContents < ActiveRecord::Migration[5.2]
  def change
    rename_table :content_statuses, :user_contents
  end
end
