class SchedulesController < ApplicationController
  before_action :authenticate_user!
  def new
    @schedule = Schedule.new
    respond_to do |format|
      format.html
      format.js
    end

    @contents = current_user.contents.where(registered: false)
  end

  def index
    @schedules = current_user.schedules
  end

  def show; end

  def create
    @contents = current_user.contents.where(registered: false)
    @schedule = current_user.schedules.build(schedule_params)

    respond_to do |format|
      if @schedule.save
        @contents.find(params[:schedule][:content_id]).update_attributes(registered: true)
        format.html
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def edit
    @contents = current_user.contents
    schedule = current_user.schedules.find(params[:id])
    @schedule = current_user.schedules.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @contents = current_user.contents
    schedule = current_user.schedules.find(params[:id])
    @schedule = current_user.schedules.find(params[:id])
    
    respond_to do |format|
      if schedule.update(schedule_params)
        format.html
        format.js
      else
        format.js { render :edit }
      end
    end
  end

  def destroy
    schedule = current_user.schedules.find(params[:id])
    @content = current_user.contents.find(schedule.content_id)
    if schedule.destroy
      @content.update_attributes(registered: false)
      redirect_to schedules_path
    else
      redirect_to schedules_path, alert: "削除が失敗しました"
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:content_id, :day, :order, :user_id)
  end
end
