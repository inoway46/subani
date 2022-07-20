class ContentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contents = current_user.contents.order(stream: :asc)
  end

  def new
    @content = Content.new
    @contents = current_user.contents
  end

  def create
    master_ids = params[:content][:master_id]
    Content.create_from_masters(master_ids, current_user)
    flash[:success] = "#{master_ids.size}件のタイトルと時間割を登録しました"
    redirect_to contents_path
  end

  def update
    @content = current_user.contents.find(params[:id])
    @content.flag_off
  end

  def destroy
    @content = current_user.contents.find(params[:id])
    respond_to do |format|
      if @content.destroy
        format.js
      else
        flash.now[:danger] = "削除に失敗しました"
        render :index
      end
    end
  end

  private

  def content_params
    params.require(:content).permit(:title, :media, :url, :stream, :new_flag, :episode, :line_flag, :master_id => [])
  end
end
