class Line::AuthenticationsController < ApplicationController
  def link
    @link_token = params[:linkToken]
  end

  def create
    @user = User.find_by(email: params[:email])
    @link_token = params[:link_token]
    if sign_in @user
      nonce = SecureRandom.urlsafe_base64(16)
      @user.update!(line_nonce: nonce)
      uri = URI("https://access.line.me/dialog/bot/accountLink")
      uri.query = URI.encode_www_form({ linkToken: @link_token, nonce: nonce })
      redirect_to uri.to_s
    else
      flash.now[:danger] = "ログイン失敗"
      render :link
    end
  end
end
