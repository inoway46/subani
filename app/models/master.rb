class Master < ApplicationRecord
  include Day
  has_many :contents, dependent: :destroy
  has_many :line_notifications

  enum stream: { default: 0, Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7 }
  
  validates :title, presence: true, length: { maximum: 255 }
  validates :media, presence: true, length: { maximum: 100 }
  validates :url, presence: true, length: { maximum: 2048 }
  validates :stream, presence: true

  scope :abema_titles, -> { where(media: "Abemaビデオ") }
  scope :amazon_titles, -> { where(media: "Amazonプライム") }
  scope :now_streaming, -> { where(season: "now") }
  scope :today, -> { where(update_day: day_of_week) }
end
