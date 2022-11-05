class LineNotification < ApplicationRecord
  attribute :total_count, type: Integer, default: 1000

  belongs_to :master
  counter_culture :master

  scope :monthly_total, -> { where(month: Time.zone.today.month) }

  def self.create_record(master, month)
    create(master_id: master.id, month: month)
  end

  def can_notify?
    total_count < 1000
  end
end
