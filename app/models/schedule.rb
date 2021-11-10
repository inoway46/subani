class Schedule < ApplicationRecord
  belongs_to :content
  belongs_to :user

  validates :day, presence: true
  validates :order, presence: true, uniqueness: { scope: :day }
  validates :content_id, presence: true, uniqueness: true
end
