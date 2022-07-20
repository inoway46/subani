class Content < ApplicationRecord
  has_one :schedule, -> { order(position: :asc) }, dependent: :destroy
  has_many :user_contents, dependent: :destroy
  has_many :users, through: :user_contents
  has_many :line_flags, dependent: :destroy
  belongs_to :master

  enum stream: { default: 0, Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7 }
  enum media: [ "Abemaビデオ", "Amazonプライム", "Netflix" ]

  validates :title, presence: true, length: { maximum: 255 }
  validates :media, presence: true, length: { maximum: 100 }
  validates :url, presence: true, length: { maximum: 2048 }
  validates :stream, presence: true

  scope :registered, -> { where(registered: true) }
  scope :unregistered, -> { where(registered: false) }
  scope :unwatched, -> { where(new_flag: true) }

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

  def self.create_from_masters(master_ids, current_user)
    master_ids.each do |master_id|
      master = Master.find(master_id.to_i)
      content = current_user.contents.create!(title: master.title, media: master.media, url: master.url, stream: master.stream, registered: false, new_flag: true, episode: master.episode, master_id: master.id)
      unless current_user.limit_position(content.stream)
        current_user.schedules.create(content_id: content.id, day: content.stream)
        content.register
      end
    end
  end
end
