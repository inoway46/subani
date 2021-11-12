class SchedulesController < ApplicationController
  before_action :authenticate_user!
  def new
    @schedule = Schedule.new
    respond_to do |format|
      format.html
      format.js
    end

    @contents = current_user.contents
  end

  def index
    @schedules = current_user.schedules
  end

  def show; end

  def create
    @contents = current_user.contents
    @schedule = current_user.schedules.build(schedule_params)

    respond_to do |format|
      if @schedule.save
        format.html
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def destroy
    schedule = current_user.schedules.find(params[:id])
    if schedule.destroy
      redirect_to schedules_path, alert: "削除しました"
    else
      redirect_to schedules_path, alert: "削除が失敗しました"
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:content_id, :day, :order, :user_id)
  end
end
