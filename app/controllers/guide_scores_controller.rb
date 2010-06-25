class GuideScoresController < ApplicationController
  def show
    @score = GuideScore.find(params[:id])
  end
end
