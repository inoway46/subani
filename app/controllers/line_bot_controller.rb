class LineBotController < ApplicationController
  require 'line/bot'

  protect_from_forgery except: :callback

  TITLE = /無職転生/

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
    @abema = Master.where(media:"Abemaビデオ").find(45).url
    if event.message['text'].match?(TITLE)
      "無職転生の再生ページです。#{@abema}"   # 定数OMAJINAIに含まれる文字列の内、いずれかに一致した投稿がされた場合に返す値
    elsif event.message['text'].match?('ruby')
      'Is it Programming language? Ore?'        # `ruby`という文字列が投稿された場合に返す値
    else
      event.message['text']                     # 上記２つに合致しない投稿だった場合、投稿と同じ文字列を返す
    end
  end
end
