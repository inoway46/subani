class Line::FlagsController < ApplicationController
  def create
    @content = current_user.contents.find(params[:id])
    if current_user.line_flags.size < 5
      @content.line_on
      current_user.add_line_flag(@content)
    else
      redirect_to contents_path, alert: "LINE通知は5タイトルまで登録できます"
    end
  end

  def destroy
    @content = current_user.contents.find(params[:id])
    if @content.line_off
      current_user.remove_line_flag(@content)
    else
      redirect_to contents_path, alert: "処理が失敗しました"
    end
  end
end
