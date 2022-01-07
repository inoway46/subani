class LineNotification < ApplicationRecord
  belongs_to :master
  counter_culture :master

  scope :monthly_total, -> { where(month: Date.today.month) }

  def self.can_notify?
    monthly_total.size < 1000
  end

  def self.create_record(master, month)
    create(master_id: master.id, month: month)
  end
end
