class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[edit update]
  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t('.update.success')
      redirect_to profile_path
    else
      flash.now[:danger] = t('.update.failure')
      render :edit
    end
  end

  private
  
  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
