module Line
  class BaseController < ApplicationController
    require 'line/bot'
    def client
      Line::Bot::Client.new do |config|
        config.channel_id = ENV["LINE_CHANNEL_ID"]
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      end
    end
  end
end
