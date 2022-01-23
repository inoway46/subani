module Line::LinkComplete
  extend ActiveSupport::Concern
  included do
    def duplicated_user(uid)
      reply_text("すでに同じLINE-IDが登録されています") if User.exists?(uid: uid)
    end

    def link_user(event, uid)
      @link_user = User.find_by(line_nonce: event.nonce.to_s)
      @link_user.update(uid: uid)
      client.link_user_rich_menu(uid, "richmenu-58b637b2558383201e55591654b3fc66")
      reply_text("アカウントの連携が完了しました")
    end
  end
end