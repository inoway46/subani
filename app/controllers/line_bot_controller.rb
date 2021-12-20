class LineBotController < ApplicationController
  require 'line/bot'

  protect_from_forgery except: :callback

  LINK = "アカウント連携/解除"
  UNLINK = "テスト"

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
      message = case event
                when Line::Bot::Event::Message
                  { type: 'text', text: parse_message_type(event) }
                else
                  { type: 'text', text: '........' }
                end
      client.reply_message(event['replyToken'], message)
    end
    head :ok
  end

  private

  def parse_message_type(event)
    case event.type
    when Line::Bot::Event::MessageType::Text
      reaction_text(event)   # ユーザーが投稿したものがテキストメッセージだった場合に返す値
    else
      'Thanks!!'             # ユーザーが投稿したものがテキストメッセージ以外だった場合に返す値
    end
  end

  def reaction_text(event)
    require 'net/http'
    require 'uri'
    require 'json'
    require 'byebug'

    client = Line::Bot::Client.new do |config|
      config.channel_secret =ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end

    if event.message['text'].match?(LINK)
      userid = "U2cebc69b40f59ece7e640c5b1ccaf125"
      response = client.create_link_token(userid).body
      link_token = JSON.parse(response)
      uri = URI("https://subani.herokuapp.com//users/sign_in")
      uri.query = URI.encode_www_form({ linkToken: link_token["linkToken"] })
      uri

    elsif event.message['text'].match?(UNLINK)
        
    else
      event.message['text']
    end
  end

  def textualize(uri)
    {
      type: "template",
      altText: "アカウント連携はこちらから",
      template: {
        type: "buttons",
        text: "以下のURLからログインし、アカウント連携を行ってください \nなお、連携の解除はいつでも行うことができます。",
        actions: [{
          type: "uri",
          label: "アカウント連携ページ",
          uri: uri
        }]
      }
    }
  end
end
