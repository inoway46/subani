class Schedule < ApplicationRecord
  belongs_to :content
  belongs_to :user
  acts_as_list scope: [:day, :user_id]

  # validate :limit_position
  validates :day, presence: true
  validates :content_id, uniqueness: true

  private

  def limit_position
    if Schedule.where(position: 5).where(day: params[:schedule][:day]).exists?
      errors.add(:base, "時間割に空きがありません")
    end
  end
end
