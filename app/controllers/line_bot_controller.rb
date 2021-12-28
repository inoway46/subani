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
        when Line::Bot::Event::AccountLink
          message= if event.result == "ok"
                    @uid = event['source']['userId']
                    @user = User.find_by(line_nonce: event.nonce.to_s)
                    if User.exists?(uid: @uid)
                      @user.update!(line_nonce: nil)
                      reply_text("すでに同じLINE-IDが登録されています")
                    else
                      @user.update!(uid: @uid, line_nonce: nil)
                      reply_text("アカウントの連携が完了しました")
                      #リッチメニューのリンク
                      client.link_user_rich_menu(@uid, "richmenu-aa208905a54e189a2a745ee27138f8e2")
                    end
                  else
                    reply_text("アカウントの連携に失敗しました")
                  end
        when Line::Bot::Event::Postback
          #連携解除で「はい」を選択
          case event['postback']['data']
          when "confirm"
            @uid = event['source']['userId']
            @user = User.find_by(uid: @uid)
            if @user.present?
              client.unlink_user_rich_menu(@uid)
              @user.update!(uid: nil)
              @user.destroy! if @user.provider = "line"
              message = reply_text("LINEアカウントの連携を解除しました")
            else
              client.unlink_user_rich_menu(@uid)
              message = reply_text("アカウントは連携されていません")
            end
          #連携解除で「いいえ」を選択
          when "cancel"
            message = reply_text("引き続きサブスク通知をお楽しみください")
          end
        when Line::Bot::Event::Message
          message = { type: 'text', text: parse_message_type(event) }
        else
          message = { type: 'text', text: '........' }
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
      'ありがとうございます'   # ユーザーが投稿したものがテキストメッセージ以外だった場合に返す値
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

    case event.message['text']
    when "アカウント連携"
      userid = event['source']['userId']
      response = client.create_link_token(userid).body
      link_token = JSON.parse(response)
      uri = URI("https://subani.herokuapp.com/line/link")
      uri.query = URI.encode_www_form({ linkToken: link_token["linkToken"] })
      "下記のリンクよりログインしてアカウント連携を行ってください。\n#{uri}"
    when "連携解除"
      message = {
        "type": "template",
        "altText": "連携解除の手続き",
        "template": {
            "type": "confirm",
            "text": "アカウント連携を解除しますか？\n※LINEログインでご利用の場合、サブスクアニメ時間割のアカウントも削除されます。",
            "actions": [
                {
                  "type": "postback",
                  "label": "はい",
                  "data": "confirm"
                },
                {
                  "type": "postback",
                  "label": "いいえ",
                  "data": "cancel"
                }
            ]
        }
      }
      client.reply_message(event['replyToken'], message)
    when "ログイン"
      @user = User.find_by(uid: event['source']['userId'])
      if @user.present?
        client.link_user_rich_menu(@user.uid, "richmenu-aa208905a54e189a2a745ee27138f8e2")
        "ログインしました"
      else
        "【アカウントが見つかりません】\nサイトからLINEログイン、もしくはアカウント連携を行ってください"
      end
    end
  end

  def reply_text(text)
    { type: 'text', text: text }
  end
end
