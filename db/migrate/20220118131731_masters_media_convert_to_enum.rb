class MastersMediaConvertToEnum < ActiveRecord::Migration[5.2]
  class TmpMaster < ApplicationRecord
    self.table_name = :masters
  end

  def change
    reversible do |dir|
      dir.up do
        change_table :masters do |table|
          table.rename :media, :old_media
        end
        add_column :masters, :media, :integer, null: false, default: 0
        TmpMaster.reset_column_information
        TmpMaster.find_each do |tr|
          tr.media = %w(Abemaビデオ Amazonプライム Netflix).index(tr.old_media)
          tr.save!
        end
        remove_column :masters, :old_media
      end

      dir.down do
        add_column :masters, :old_media, :string
        TmpMaster.reset_column_information
        TmpMaster.find_each do |tr|
          r = master.find(tr.id)
          tr.old_media = r.media
          tr.save!
        end
        remove_column :masters, :media
        change_table :masters do |table|
          table.rename :old_media, :media
        end
      end
    end
  end
end
