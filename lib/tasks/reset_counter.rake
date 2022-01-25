namespace :reset_counter do
  desc 'LINE通知のカウンターを月初にリセット'
  task line_notifications: :environment do
    include Day
    if first_day?
      p "#{last_month}のLINE通知数は#{Content.total_line_notification}件でした"
      Content.reset_counter
      p "LINE通知数をリセットしました"
    else
      p "#{yesterday}時点のLINE通知数は#{Content.total_line_notification}件です"
    end
  end
end
