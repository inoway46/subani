class LineBotController < ApplicationController
  require 'line/bot'

  protect_from_forgery except: :callback

  def callback
    client = Line::Bot::Client.new do |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret =ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end

    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return head :bad_request unless client.validate_signature(body, signature)

    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Follow
        message = reply_confirm_linking_account
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
        message = reply_text_message(event)
        end
      when Line::Bot::Event::Unfollow
        # rplyTokenは発行されない
        # 連携解除処理
      end
      client.reply_message(event['replyToken'], message)
    end

    # 200status は必ず返さなければならない
    head :ok
  end

  private

  def reply_confirm_linking_account
    {
      type: "template",
      altText: "LINEアカウントの連携をしてください",
      template: {
        type: "confirm",
        text: "LINEアカウントの連携をしてください。 \n" + "なお、連携の解除はいつでも行うことができます。",
        actions: [
          {
            type: "message",
            label: "Yes",
            text: "do linking"
          },
          {
            type: "message",
            label: "No",
            text: "don't linking"
          }
        ]
      }
    }
  end

  def reply_text_message(event)
    reply_text = case event.message['text']
        when "do linking"
          set_url_for_linking(event.source.userId)
        when "don't linking"
          "引き続きLINE通知以外の機能をご利用ください"
        when "hi"
          "Good morning!"
        when "bye"
          "Good bye!"
        else
          # 所定の文言以外にはエラーメッセージを返す
          "メッセージを読み取れませんでした"
        end
    { type: 'text', text: reply_text }
  end

  def set_url_for_linking(line_id)
    # 連携手順1. 連携トークンを発行する
    token = require_link_token(line_id)

    # 連携手順2. ユーザーを連携URLにリダイレクトする
    {
      type: "template",
      altText: "アカウント連携用ページ",
      template: {
        type: "buttons",
        text: "以下のURLから再度ログインし、アカウント連携を行ってください",
        defaultAction: {
          type: "uri",
          label: "アカウント連携ページ",
          uri: "https://subani.herokuapp.com/line/link?linkToken=#{ token['linkToken'] }"
        },
        actions: [
          {
            type: "uri",
            label: "アカウント連携ページ",
            uri: "https://subani.herokuapp.com/line/link?linkToken=#{ token['linkToken'] }"
          }
        ]
      }
    }
  end

  def require_link_token(line_id)
    client = Line::Bot::Client.new do |config|
      config.channel_secret =ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
    client.create_link_token(line_id)
  end
end
end
