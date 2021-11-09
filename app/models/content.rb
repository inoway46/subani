class Content < ApplicationRecord
  has_one :schedule

  enum stream: { default: 0, Sun: 1, Mon: 2, Tue: 3, Wed: 4, Thu: 5, Fri: 6, Sat: 7 }

  validates :title, presence: true, length: { maximum: 255 }
  validates :media, presence: true, length: { maximum: 100 }
  validates :url, presence: true, length: { maximum: 2048 }
end
