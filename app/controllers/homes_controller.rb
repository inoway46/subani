class HomesController < ApplicationController
  def index; end

  def terms; end

  def privacy; end

  def guest_sign_in
    user = User.find_or_create_by!(email: 'guest@example.com', guest: true) do |user|
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
    sign_in user
    redirect_to contents_path, notice: t('.guest_sign_in.success')
  end
end