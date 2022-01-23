class Schedule < ApplicationRecord
  belongs_to :content
  belongs_to :user
  acts_as_list scope: [:day, :user_id]

  # validate :limit_position
  validates :day, presence: true
  validates :content_id, uniqueness: true

  scope :today, -> { where(day: Date.today.strftime("%a")) }

  def no_position_error
    self.errors.add(:base, "時間割に空きがありません")
  end
end
