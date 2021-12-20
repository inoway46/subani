class ApplicationController < ActionController::Base
  #before_action :configure_permitted_parameters
  def after_sign_in_path_for(resource)
    schedules_path(resource)
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:line_nonce])
  end
end
