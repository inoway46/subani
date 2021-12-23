class LineBotController < ApplicationController
  require 'line/bot'

  protect_from_forgery except: :callback

  LINK = "アカウント連携"
  UNLINK = "連携解除"

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
                when Line::Bot::Event::AccountLink
                  if event.result == "ok"
                    @line_id = event['source']['userId']
                    @user = User.find_by(line_nonce: event.nonce.to_s)
                    if User.exists?(uid: @line_id)
                      @user.update!(line_nonce: nil)
                      reply_text("すでに同じLINE-IDが登録されています")
                    else
                      @user.update!(uid: @line_id, line_nonce: nil)
                      reply_text("アカウントの連携が完了しました")
                    end
                  else
                    reply_text("アカウントの連携に失敗しました")
                  end
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
      'ありがとうございます'             # ユーザーが投稿したものがテキストメッセージ以外だった場合に返す値
    end
  end

  def reaction_text(event)
    require 'net/http'
    require 'uri'
    require 'json'

    client = Line::Bot::Client.new do |config|
      config.channel_secret =ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end

    #アカウント連携
    if event.message['text'].match?(LINK)
      userid = event['source']['userId']
      response = client.create_link_token(userid).body
      link_token = JSON.parse(response)
      uri = URI("https://6301-2001-ce8-131-389f-6d78-e620-5f35-ad74.ngrok.io/line/link")
      uri.query = URI.encode_www_form({ linkToken: link_token["linkToken"] })
      message = {
        type: "template",
        altText: "アカウント連携はこちら",
        template: {
          type: "buttons",
          text: "以下のリンクからログインし、アカウント連携を行ってください \nなお、連携の解除はメニューからいつでも行えます。",
          actions: [{
            type: "uri",
            label: "アカウント連携ページ",
            uri: uri
          }]
        }
      }
      client.reply_message(event['replyToken'], message)
    #連携解除
    elsif event.message['text'].match?(UNLINK)
        @user = User.find_by(uid: event['source']['userId'])
        if @user.present?
          @user.update!(uid: nil)
          "LINEアカウントの連携を解除しました"
        else
          "アカウントは連携されていません"
        end
    else
      event.message['text']
    end
  end

  def reply_text(text)
    { type: 'text', text: text }
  end
end
