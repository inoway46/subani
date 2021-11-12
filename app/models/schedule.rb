class Schedule < ApplicationRecord
  belongs_to :content
  belongs_to :user

  validates :day, presence: true
  validates :order, presence: true, uniqueness: { scope: [:day, :user_id] }
  validates :content_id, uniqueness: true
end
