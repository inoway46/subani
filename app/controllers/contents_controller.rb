class ContentsController < ApplicationController
  before_action :authenticate_user!
  def new
    @content = Content.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
    @contents = current_user.contents.order(stream: :asc)
  end

  def show
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

  def create
    @content = current_user.contents.build(content_params)

    respond_to do |format|
      if @content.save
        format.html
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def destroy
    content = current_user.contents.find(params[:id])
    if content.destroy
      redirect_to contents_path, notice: "削除しました"
    else
      redirect_to contents_path, alert: "削除が失敗しました"
    end
  end

  private

  def content_params
    params.require(:content).permit(:title, :media, :url, :stream)
  end
end
