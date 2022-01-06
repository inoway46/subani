class LineNotification < ApplicationRecord
  belongs_to :user
  belongs_to :content
  counter_culture :user

  def self.can_notify?
    User.all.sum(:line_notifications_count) < 1000
  end
end
