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

    def reply_text(text)
      { type: 'text', text: text }
    end

    def unlink_message
      {
        type: "template",
        altText: "連携解除の手続き",
        template: {
            type: "confirm",
            text: "アカウント連携を解除しますか？\n※LINEログインでご利用の場合、サブスクアニメ時間割のアカウントも削除されます。",
            actions: [
                {
                  type: "postback",
                  label: "はい",
                  data: "confirm"
                },
                {
                  type: "postback",
                  label: "いいえ",
                  data: "cancel"
                }
            ]
        }
      }
    end

    def after_login_menu
      "richmenu-58b637b2558383201e55591654b3fc66"
    end
  end
end
