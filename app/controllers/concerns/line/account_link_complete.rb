module Line
  module AccountLinkComplete
    extend ActiveSupport::Concern
    included do
      def duplicated_user(uid)
        reply_text("すでに同じLINE-IDが登録されています") if User.exists?(uid:)
      end

      def link_user(event, uid)
        @link_user = User.find_by(line_nonce: event.nonce.to_s)
        @link_user.update(uid:)
        client.link_user_rich_menu(uid, after_login_menu)
        reply_text("アカウントの連携が完了しました")
      end
    end
  end
end
