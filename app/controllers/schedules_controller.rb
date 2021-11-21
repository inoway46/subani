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
      if Schedule.where(position: 5).where(day: params[:schedule][:day]).exists?
        @schedule.errors.add(:base, "時間割に空きがありません")
        format.js { render :new }
      else
        @schedule.save
        @contents.find(params[:schedule][:content_id]).update_attributes(registered: true)
        format.html
        format.js
      end
    end
  end

  def edit
    @contents = current_user.contents
    @schedule = current_user.schedules.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @contents = current_user.contents
    @schedule = current_user.schedules.find(params[:id])
    
    respond_to do |format|
      if Schedule.where(position: 5).where(day: params[:schedule][:day]).exists?
        @schedule.errors.add(:base, "時間割に空きがありません")
        format.js { render :edit }
      else
        @schedule.update(schedule_params)
        format.html
        format.js
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
    params.require(:schedule).permit(:content_id, :day, :user_id)
  end
end
