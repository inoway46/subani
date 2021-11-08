class Content < ApplicationRecord
  has_one :schedule

  validates :title, presence: true, length: { maximum: 255 }
  validates :media, presence: true, length: { maximum: 100 }
  validates :url, presence: true, length: { maximum: 2048 }
end
