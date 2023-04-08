class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    basic_action
  end

  private

  def basic_action
    @omniauth = request.env["omniauth.auth"]
    return if @omniauth.blank?

    @profile = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
    return if @profile.provider.to_s != @omniauth["provider"].to_s || @profile.uid != @omniauth["uid"]

    if @profile.email.blank?
      email = @omniauth["info"]["email"] || "#{@omniauth['uid']}-#{@omniauth['provider']}@example.com"
      @profile = current_user || User.create!(provider: @omniauth["provider"], uid: @omniauth["uid"], email:, name: @omniauth["info"]["name"], password: Devise.friendly_token[0, 20])
    end
    sign_in(:user, @profile)
    flash[:notice] = t('.basic_action.success')
    redirect_to contents_path
  end

  def fake_email(_uid, _provider)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
