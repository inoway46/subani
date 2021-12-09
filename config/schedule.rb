# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + "/environment")

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所。ここでエラー内容を確認する
set :output, "#{Rails.root}/log/cron.log"

# 毎朝6時に配信曜日ごとにスクレイピングを行う
every :monday, at: '6am' do
  rake "scraping_episode:abema_sun"
  rake "scraping_episode:abema_mon"
end

every :tuesday, at: '6am' do
  rake "scraping_episode:abema_mon"
  rake "scraping_episode:abema_tue"
end

every :wednesday, at: '6am' do
  rake "scraping_episode:abema_tue"
  rake "scraping_episode:abema_wed"
end

every :thursday, at: '6am' do
  rake "scraping_episode:abema_wed"
  rake "scraping_episode:abema_thu"
end

every :friday, at: '6am' do
  rake "scraping_episode:abema_thu"
  rake "scraping_episode:abema_fri"
end

every :saturday, at: '6am' do
  rake "scraping_episode:abema_fri"
  rake "scraping_episode:abema_sat"
end

every :sunday, at: '6am' do
  rake "scraping_episode:abema_sat"
  rake "scraping_episode:abema_sun"
end

# 毎日15時に再度スクレイピングを行う
every :monday, at: '3pm' do
  rake "scraping_episode:abema_mon"
end

every :tuesday, at: '3pm' do
  rake "scraping_episode:abema_tue"
end

every :wednesday, at: '3pm' do
  rake "scraping_episode:abema_wed"
end

every :thursday, at: '3pm' do
  rake "scraping_episode:abema_thu"
end

every :friday, at: '3pm' do
  rake "scraping_episode:abema_fri"
end

every :saturday, at: '3pm' do
  rake "scraping_episode:abema_sat"
end

every :sunday, at: '3pm' do
  rake "scraping_episode:abema_sun"
end