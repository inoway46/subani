class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_domain, if: :production?
  FQDN = 'subani.net'

  def ensure_domain
    return unless /\.herokuapp.com/ =~ request.host
    port = ":#{request.port}" unless [80, 443].include?(request.port)
    redirect_to "#{request.protocol}#{FQDN}#{port}#{request.path}", status: :moved_permanently
  end

  def after_sign_in_path_for(resource)
    contents_path(resource)
  end

  def after_sign_out_path_for(resource)
    if @user.guest?
      new_user_registration_path
    else
      root_path
    end
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:uid])
  end

  def production?
    Rails.env.production?
  end
end
