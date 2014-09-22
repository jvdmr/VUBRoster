class LecturesController < ApplicationController
  def show
    @lecture = Lecture.find(params[:id])
  end

  def remove
    if params[:id]
      @lecture = CustomLecture.find params[:id]
      @lecture.destroy
    end
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove "lectures_" + params[:nr].to_s
        end
      end
    end
  end

  def add
    @lecture = CustomLecture.new
    @nr = params[:nr].to_i
    respond_to do |format|
      format.js
    end
  end
end
