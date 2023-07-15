module Api
  class ContentsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      if current_user
        contents = current_user.contents.order(stream: :asc)
        render json: { contents: }
      else
        render json: { message: 'ログインしてください' }
      end
    end
  end
end
