class SchedulesController < ApplicationController
  before_action :authenticate_user!
  def new
    @schedule = Schedule.new
    respond_to do |format|
      format.js
    end

    @contents = current_user.contents.unregistered
  end

  def index
    @schedules = current_user.schedules.preload(:content)
  end

  def create
    @contents = current_user.contents.unregistered
    @schedule = current_user.schedules.build(schedule_params)

    if current_user.limit_position(params[:schedule][:day])
      @schedule.no_position_error
      render :new
    else
      @schedule.save!
      @contents.find(params[:schedule][:content_id]).register
      redirect_to schedules_path
    end
  end

  def edit
    @contents = current_user.contents
    @schedule = current_user.schedules.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @contents = current_user.contents
    @schedule = current_user.schedules.find(params[:id])
    if current_user.limit_position(params[:schedule][:day])
      @schedule.no_position_error
      render :edit
    else
      @schedule.update(schedule_params)
      redirect_to schedules_path
    end
  end

  def destroy
    schedule = current_user.schedules.find(params[:id])
    @content = current_user.contents.find(schedule.content_id)
    if schedule.destroy
      @content.unregister
      redirect_to schedules_path
    else
      redirect_to schedules_path, alert: "削除が失敗しました"
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:content_id, :day)
  end
end
