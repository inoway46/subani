require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

every 1.day, at: '6:00' do
  rake "scraping_episode:abema"
end

every 1.day, at: '6:05' do
  rake "scraping_episode:amazon"
end

every 1.day, at: '6:10' do
  rake "scraping_episode:netflix"
end

every 1.day, at: '6:15' do
  rake "master_csv:export"
end

every 1.day, at: '16:00' do
  rake "scraping_episode:abema"
end

every 1.day, at: '16:05' do
  rake "scraping_episode:amazon"
end

every 1.day, at: '16:10' do
  rake "scraping_episode:netflix"
end

every 1.day, at: '16:15' do
  rake "master_csv:export"
end