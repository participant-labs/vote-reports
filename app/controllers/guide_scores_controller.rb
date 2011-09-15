class GuideScoresController < ApplicationController
  def show
    @score = GuideScore.find(params[:id])
    render layout: false
  end
end
