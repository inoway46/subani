module Line
  class FlagsController < ApplicationController
    def create
      @content = current_user.contents.find(params[:id])
      if current_user.line_flags.size < 5
        @content.line_on
        current_user.add_line_flag(@content)
      else
        flash[:info] = t('.create.info')
        redirect_to contents_path
      end
    end

    def destroy
      @content = current_user.contents.find(params[:id])
      if @content.line_off
        current_user.remove_line_flag(@content)
      else
        flash[:danger] = t('.destroy.danger')
        redirect_to contents_path
      end
    end
  end
end
