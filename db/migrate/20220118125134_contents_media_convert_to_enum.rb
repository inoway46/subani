class ContentsMediaConvertToEnum < ActiveRecord::Migration[5.2]
  class TmpContent < ApplicationRecord
    self.table_name = :contents
  end

  def change
    reversible do |dir|
      dir.up do
        change_table :contents do |table|
          table.rename :media, :old_media
        end
        add_column :contents, :media, :integer, null: false, default: 0
        TmpContent.reset_column_information
        TmpContent.find_each do |tr|
          tr.media = %w(Abemaビデオ Amazonプライム Netflix).index(tr.old_media)
          tr.save!
        end
        remove_column :contents, :old_media
      end

      dir.down do
        add_column :contents, :old_media, :string
        TmpContent.reset_column_information
        TmpContent.find_each do |tr|
          r = Content.find(tr.id)
          tr.old_media = r.media
          tr.save!
        end
        remove_column :contents, :media
        change_table :contents do |table|
          table.rename :old_media, :media
        end
      end
    end
  end
end
