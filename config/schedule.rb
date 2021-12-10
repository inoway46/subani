# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + "/environment")

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所。ここでエラー内容を確認する
set :output, "#{Rails.root}/log/cron.log"

# 毎朝6時と15時にスクレイピングを行う
every :day, at: '6am' do
  rake "scraping_episode:abema_all"
end

every :day, at: '3pm' do
  rake "scraping_episode:abema_all"
end