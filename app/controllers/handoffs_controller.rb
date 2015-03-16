class HandoffsController < ApplicationController
  def index
  end

  def show
    @handoff = Handoff.find(params[:id])
  end

  def create
  end

  def destroy
  end
end
