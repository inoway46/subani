class ContentsController < ApplicationController
  def new
    @content = Content.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
  end

  def show
  end

  def create
    @content = Content.new(content_params)

    respond_to do |format|
      if @content.save
        format.html
        format.json
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def destroy
  end

  private

  def content_params
    params.require(:content).permit(:title, :media, :url)
  end
end
