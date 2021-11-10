class ContentsController < ApplicationController
  def new
    @content = Content.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
    @contents = Content.all
  end

  def show
  end

  def edit
    @content = Content.find_by(id: params[:id])
  end

  def update
    @content = Content.find(params[:id])
    
    if @content.update(content_params)
      redirect_to contents_path, notice: "更新しました"
    else
      render :edit
    end
  end

  def create
    @contents = Content.all
    @content = Content.new(content_params)

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
    content = Content.find(params[:id])
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
