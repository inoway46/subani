class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?
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
end
