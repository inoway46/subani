source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.0.4'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
gem 'redis'
gem 'sidekiq'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap'
# bootstrapの導入
gem 'bootstrap'
gem 'jquery-rails'
# enumの日本語化
gem 'enum_help'
gem 'rails-i18n'
# ログイン機能の実装
gem 'devise'
gem 'devise-i18n'
# 管理画面の実装
gem 'rails_admin'
gem 'rails_admin-i18n'
gem 'cancancan'
# GraphQLの導入
gem 'graphql-client'
# 時間割の自動配置
gem 'acts_as_list'
# rake_taskの定期実行
gem 'whenever'
# スクレイピング用
gem 'selenium-webdriver'
gem 'webdrivers'
gem 'capybara'
# 環境変数の管理
gem 'dotenv-rails'
# S3へのアップロード
gem 'aws-sdk-s3'
# LINEで最新話の更新を通知する
gem 'line-bot-api'
# LINEログイン用
gem 'omniauth-line'
gem "omniauth-rails_csrf_protection"
# デコレーターの導入
gem 'draper'
# LINE通知数のカウント
gem 'counter_culture'
# OGPの設定
gem 'meta-tags'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rails-erd'
  gem 'rubocop', require:false
  gem 'rubocop-rails', require:false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rubycw', require: false
  gem 'faker'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'i18n-tasks' # i18nの整理用
  gem 'localhost' # localhostにhttpsで接続
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end

group :production do
  gem 'pg'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "sassc-rails"
