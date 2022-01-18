class Master < ApplicationRecord
  include Day
  has_many :contents, dependent: :destroy
  has_many :line_notifications

  enum stream: { default: 0, Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7 }
  enum media: [ "Abemaビデオ", "Amazonプライム", "Netflix" ]
  
  validates :title, presence: true, length: { maximum: 255 }
  validates :media, presence: true, length: { maximum: 100 }
  validates :url, presence: true, length: { maximum: 2048 }
  validates :stream, presence: true

  scope :media_titles, ->(media) { where(media: media) }
  scope :now_streaming, -> { where(season: "now") }
  scope :today, -> { where(update_day: day_of_week) }
  scope :onair, -> { where.not(episode: 0) }

  def self.total_line_notification
    all.sum(:line_notifications_count)
  end

  def self.reset_counter
    update_all(line_notifications_count: 0)
  end
end
