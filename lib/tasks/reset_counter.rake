namespace :reset_counter do
  desc 'LINE通知のカウンターを月初にリセット'
  task line_notifications: :environment do
    include Day
    reset_counter if first_day?
  end
end
