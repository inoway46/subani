class Line::NotificationsController < ApplicationController
  def update
    @content = current_user.contents.find(params[:content_id])
    respond_to do |format|
      if @content.update(content_params)
        format.js
      else
        redirect_to contents_path, alert: "処理が失敗しました"
      end
    end
  end

  def destroy
    @content = current_user.contents.find(params[:content_id])
    if @content.destroy
      redirect_to contents_path, alert: "削除しました"
    else
      redirect_to contents_path, alert: "削除が失敗しました"
    end
  end
end
