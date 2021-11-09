class SchedulesController < ApplicationController
  def new
    @schedule = Schedule.new
    respond_to do |format|
      format.html
      format.js
    end

    @contents = Content.all
  end

  def index
    @contents = Content.all
    @schedules = Schedule.all
  end

  def show
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @contents = Content.all

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
  end

  private

  def schedule_params
    params.require(:schedule).permit(:content_id, :day, :order)
  end
end
