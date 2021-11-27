class Content < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  has_one :schedule, -> { order(position: :asc) }, dependent: :destroy
  has_many :content_statuses, dependent: :destroy
  has_many :users, through: :content_statuses
  belongs_to_active_hash :master

  enum stream: { default: 0, Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7 }

  validates :title, presence: true, length: { maximum: 255 }
  validates :media, presence: true, length: { maximum: 100 }
  validates :url, presence: true, length: { maximum: 2048 }
end
