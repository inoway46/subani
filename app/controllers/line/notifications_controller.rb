class Line::NotificationsController < ApplicationController
  def create
    @content = current_user.contents.find(params[:id])
    respond_to do |format|
      if @content.line_on
        format.js
      else
        redirect_to contents_path, alert: "処理が失敗しました"
      end
    end
  end

  def destroy
    @content = current_user.contents.find(params[:id])
    respond_to do |format|
      if @content.line_off
        format.js
      else
        redirect_to contents_path, alert: "処理が失敗しました"
      end
    end
  end

  private

  def content_params
    params.require(:content).permit(:line_flag)
  end
end
