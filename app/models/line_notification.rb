class LineNotification < ApplicationRecord
  belongs_to :content
  counter_culture :content

  scope :monthly_total, -> { where(month: Date.today.month) }

  def self.can_notify?
    monthly_total.size < 1000
  end

  def self.create_record(content, month)
    create(content_id: content.id, month: month)
  end
end
