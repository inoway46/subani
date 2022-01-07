class Content < ApplicationRecord
  has_one :schedule, -> { order(position: :asc) }, dependent: :destroy
  has_many :user_contents, dependent: :destroy
  has_many :users, through: :user_contents
  has_many :line_flags, dependent: :destroy
  belongs_to :master

  enum stream: { default: 0, Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7 }

  validates :title, presence: true, length: { maximum: 255 }
  validates :media, presence: true, length: { maximum: 100 }
  validates :url, presence: true, length: { maximum: 2048 }
  validates :stream, presence: true

  scope :registered, -> { where(registered: true) }
  scope :unregistered, -> { where(registered: false) }

  def register
    update(registered: true)
  end

  def unregister
    update(registered: false)
  end

  def flag_off
    update(new_flag: false)
  end

  def line_on
    update(line_flag: true)
  end

  def line_off
    update(line_flag: false)
  end
end
