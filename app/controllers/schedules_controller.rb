class SchedulesController < ApplicationController
  def new
    @schedule = Schedule.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
  end

  def show
  end

  def create
    @schedule = Schedule.new(schedule_params)

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
