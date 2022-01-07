class LineNotification < ApplicationRecord
  belongs_to :master
  counter_culture :master

  def self.can_notify?
    Master.all.sum(:line_notifications_count) < 1000
  end

  def self.create_record(master, month)
    create(master_id: master.id, month: month)
  end

  def reset_counter
    Master.update_all(line_notifications_count: 0)
  end
end
