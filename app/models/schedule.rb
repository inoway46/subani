class Schedule < ApplicationRecord
  validates :day, presence: true
  validates :order, presence: true
  validates :content_id, presence: true, uniquness: true
end
