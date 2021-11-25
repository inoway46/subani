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

  def master
    @content = Content.new
  end

  def new
    @content = Content.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @content = current_user.contents.build(content_params)
    
    unless params[:content][:master_id] #タイトル一覧からの追加（マスタ登録ではない時）
      respond_to do |format|
        if @content.save
          unless current_user.schedules.where(position: 5).where(day: @content.stream_i18n).exists?
            current_user.schedules.create!(content_id: @content.id, day: @content.stream_i18n)
            @content.update(registered: true)
          end
          format.html
          format.js
        else
          format.js { render :new }
        end
      end

    else #マスタ登録からの追加
      @master_ids = params[:content][:master_id]
      @master_ids.each do |master_id|
        master = Master.find(master_id.to_i)
        @content = current_user.contents.create!(title: master.title, media: master.media, url: master.url, stream: master.stream)
        current_user.schedules.create!(content_id: @content.id, day: @content.stream_i18n)
      end
      redirect_to contents_path, alert: "#{@master_ids.size}件のタイトルと時間割を登録しました"
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

  def destroy
    @content = current_user.contents.find(params[:id])

    respond_to do |format|
      if @content.destroy
        format.html
        format.js
      else
        redirect_to contents_path, alert: "削除が失敗しました"
      end
    end
  end

  private

  def content_params
    params.require(:content).permit(:title, :media, :url, :stream, :user_id, :master_id => [])
  end

  def result
    response = Subani::Client.query(Query)
  end
end
