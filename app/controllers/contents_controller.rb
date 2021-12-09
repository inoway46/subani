class ContentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contents = current_user.contents.order(stream: :asc)
  end

  def show
  end

  def ranking
    @works = result.data.to_h["searchWorks"]["edges"]
  end

  def amazon_list
    @content = Content.new
    @contents = current_user.contents
  end

  def abema_list
    @content = Content.new
    @contents = current_user.contents
  end

  def new
    @content = Content.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    if params[:content][:master_id]
      @master_ids = params[:content][:master_id]
      @master_ids.each do |master_id|
        master = Master.find(master_id.to_i)
        @content = current_user.contents.create!(title: master.title, media: master.media, url: master.url, stream: master.stream, registered: true, episode: master.episode, master_id: master.id)
        current_user.schedules.create!(content_id: @content.id, day: @content.stream_i18n)
      end
      redirect_to contents_path, alert: "#{@master_ids.size}件のタイトルと時間割を登録しました"
    else
      render :index, alert: "タイトル登録が失敗しました"
    end
  end

  def edit
    @content = current_user.contents.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @content = current_user.contents.find(params[:id])
    
    respond_to do |format|
      if @content.update(content_params)
        format.html
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
    params.require(:content).permit(:title, :media, :url, :stream, :new_flag, :episode, :master_id => [])
  end

  def result
    response = Subani::Client.query(Query)
  end
end
