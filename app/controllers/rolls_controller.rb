class RollsController < ApplicationController
  def show
    @roll = Roll.find(params[:id])
  end
end
