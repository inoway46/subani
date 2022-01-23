module Line
  class LineBotController < Line::BaseController
    require 'line/bot'
    include Day
    include AccountLinkCreate
    include ResponseTitle
    include LinkComplete

    protect_from_forgery except: :callback

    def callback
      body = request.body.read
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      return head :bad_request unless client.validate_signature(body, signature)

      events = client.parse_events_from(body)
      events.each do |event|
        @uid = event['source']['userId']
        @user = User.find_by(uid: @uid)
        case event
          when Line::Bot::Event::AccountLink
            message = if event.result == "ok"
                        duplicated_user(@uid) || link_user(event, @uid)
                      else
                        reply_text("アカウントの連携に失敗しました")
                      end
          when Line::Bot::Event::Postback
            #連携解除で「はい」を選択
            case event['postback']['data']
            when "confirm"
              message = if @user.present?
                          client.unlink_user_rich_menu(@uid)
                          @user.update(uid: nil)
                          @user.destroy if @user.provider.present?
                          reply_text("LINEアカウントの連携を解除しました")
                        else
                          client.unlink_user_rich_menu(@uid)
                          reply_text("アカウントは連携されていません")
                        end
            #連携解除で「いいえ」を選択
            when "cancel"
              message = reply_text("引き続きサブスク通知をお楽しみください")
            end
          when Line::Bot::Event::Message
            message = reply_text(parse_message_type(event))
          end
        client.reply_message(event['replyToken'], message)
      end
      head :ok
    end

    private

    def parse_message_type(event)
      case event.type
      when Line::Bot::Event::MessageType::Text
        reaction_text(event)
      else
        'ありがとうございます'
      end
    end

    def reaction_text(event)
      case event.message['text']
      when "アカウント連携"
        link_token = create_token(@uid)
        uri = create_uri(link_token)
        "下記のリンクよりログインしてアカウント連携を行ってください。\n#{uri}"
      when "連携解除"
        if @user.blank?
          client.unlink_user_rich_menu(@uid)
          "アカウントが見つかりませんでした"
        else
          client.reply_message(event['replyToken'], unlink_message)
        end
      when "ログイン"
        if @user.present?
          client.link_user_rich_menu(@user.uid, "richmenu-58b637b2558383201e55591654b3fc66")
          "ログインしました"
        else
          "【アカウントが見つかりません】\nサイトからLINEログイン、もしくはアカウント連携を行ってください"
        end
      when "ログアウト"
        client.unlink_user_rich_menu(@uid)
        @user.present? ? "ログアウトしました" : "アカウントが見つかりませんでした"
      when "今日のアニメ"
        if @user.present?
          anime_lists = @user.schedules.today
          anime_lists.present? ? answer_titles_today(anime_lists) : "#{today_jp}曜日のアニメは時間割に登録されていません"
        else
          "アカウントが見つかりませんでした"
          client.unlink_user_rich_menu(@uid)
        end
      when "未視聴アニメ"
        if @user.present?
          ids = @user.schedules.pluck(:content_id)
          anime_lists = Content.where(id: ids).unwatched
          anime_lists.present? ? answer_titles_unwatched(anime_lists) : "現在、未視聴のアニメはありません"
        else
          "アカウントが見つかりませんでした"
          client.unlink_user_rich_menu(@uid)
        end
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
  end
end
