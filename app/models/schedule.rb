class Schedule < ApplicationRecord
  belongs_to :content
  belongs_to :user
  acts_as_list scope: [:day, :user_id]

  # validate :limit_position
  validates :day, presence: true
  validates :content_id, uniqueness: true
end
