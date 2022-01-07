namespace :reset_counter do
  desc 'LINE通知のカウンターを月初にリセット'
  task line_notifications: :environment do
    include Day
    if first_day?
      Master.reset_counter
      p "LINE通知数をリセットしました"
    else
      p "現在のLINE通知数は#{Master.total_line_notification}件です"
    end
  end
end
