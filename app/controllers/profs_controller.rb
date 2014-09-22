class ProfsController < ApplicationController
  def show
    @prof = Prof.find params[:id]
  end
end
