class Master < ApplicationRecord
  has_many :contents, dependent: :destroy

  enum stream: { default: 0, Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7 }
  
  validates :title, presence: true, length: { maximum: 255 }
  validates :media, presence: true, length: { maximum: 100 }
  validates :url, presence: true, length: { maximum: 2048 }
  validates :stream, presence: true
end
