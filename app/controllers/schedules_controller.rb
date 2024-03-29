class SchedulesController < ApplicationController
  before_action :authenticate_user!
  def index
    @schedules = current_user.schedules.preload(:content)
  end

  def new
    @schedule = Schedule.new
    @contents = current_user.contents.unregistered
  end

  def edit
    @contents = current_user.contents
    @schedule = current_user.schedules.find(params[:id])
  end

  def create
    @contents = current_user.contents.unregistered
    @schedule = current_user.schedules.build(schedule_params)

    if current_user.limit_position(params[:schedule][:day])
      @schedule.no_position_error
      render :new
    else
      @schedule.save
      @contents.find(params[:schedule][:content_id]).register
      flash[:success] = "「#{@schedule.content.title}」を時間割登録しました"
      redirect_to schedules_path
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
      flash[:success] = t('.update.success', title: @schedule.content.title)
      redirect_to schedules_path
    end
  end

  def destroy
    schedule = current_user.schedules.find(params[:id])
    @content = current_user.contents.find(schedule.content_id)
    if schedule.destroy
      @content.unregister
      flash[:info] = t('.destroy.success', title: @content.title)
    else
      flash[:danger] = t('.destroy.failure')
    end
    redirect_to schedules_path
  end

  private

  def schedule_params
    params.require(:schedule).permit(:content_id, :day)
  end
end
