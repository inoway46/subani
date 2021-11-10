class SchedulesController < ApplicationController
  def new
    @schedule = Schedule.new
    respond_to do |format|
      format.html
      format.js
    end

    @contents = Content.all.includes(:user)
  end

  def index
    @schedules = Schedule.all.includes(:user)
  end

  def show; end

  def create
    @schedule = current_user.schedules.build(schedule_params)

    respond_to do |format|
      if @schedule.save
        format.html
        format.json
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def destroy
    schedule = current_user.schedules.find(params[:id])
    if schedule.destroy
      redirect_to schedules_path, notice: "削除しました"
    else
      redirect_to schedules_path, alert: "削除が失敗しました"
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:content_id, :day, :order)
  end
end
