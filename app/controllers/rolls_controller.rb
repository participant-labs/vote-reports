class RollsController < ApplicationController
  def show
    @roll = Roll.find(params[:id], include: [:subject])
  end
end
