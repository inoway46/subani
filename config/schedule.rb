# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + "/environment")

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所。ここでエラー内容を確認する
set :output, "#{Rails.root}/log/cron.log"

# 毎朝6時にスクレイピングを行う
every 1.day, at: '6:00' do
  rake "scraping_episode:abema_all"
end

every 1.day, at: '6:05' do
  rake "scraping_episode:amazon_all"
end

# スクレイピングで更新後のMasterをCSV化してS3にアップロード
every 1.day, at: '6:15' do
  rake "master_csv:export"
end