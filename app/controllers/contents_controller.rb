class ContentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contents = current_user.contents.order(stream: :asc)
  end

  def amazon_list
    @content = Content.new
    @contents = current_user.contents
  end

  def abema_list
    @content = Content.new
    @contents = current_user.contents
  end

  def create
    @master_ids = params[:content][:master_id]
    @master_ids.each do |master_id|
      master = Master.find(master_id.to_i)
      @content = current_user.contents.create!(title: master.title, media: master.media, url: master.url, stream: master.stream, registered: false, new_flag: true, episode: master.episode, master_id: master.id)
      unless current_user.schedules.where(position: 5).where(day: @content.stream).present?
        current_user.schedules.create!(content_id: @content.id, day: @content.stream)
        @content.update!(registered: true)
      end
    end
    redirect_to contents_path, alert: "#{@master_ids.size}件のタイトルと時間割を登録しました"
  end

  def edit
    @content = current_user.contents.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @content = current_user.contents.find(params[:id])
    
    respond_to do |format|
      if @content.update(content_params)
        format.js
      else
        format.js { render :edit }
      end
    end
  end

  def flag_off
    @content = current_user.contents.find(params[:id])
    if @content.update(content_params)
      redirect_to schedules_path
    else
      redirect_to schedules_path, alert: "処理が失敗しました"
    end
  end

  def destroy
    @content = current_user.contents.find(params[:id])
    if @content.destroy
      redirect_to contents_path, alert: "削除しました"
    else
      redirect_to contents_path, alert: "削除が失敗しました"
    end
  end

  private

  def content_params
    params.require(:content).permit(:title, :media, :url, :stream, :new_flag, :episode, :line_flag, :master_id => [])
  end
end
