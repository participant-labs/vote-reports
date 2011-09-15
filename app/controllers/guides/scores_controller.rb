class Guides::ScoresController < ApplicationController
  before_filter :load_guide

  def show
    @report = @guide.report
    @score = @report.scores.find(params[:id])
    respond_to do |format|
      format.html
      format.js {
        render layout: false
      }
    end
  end

  private

  def load_guide
    @guide = Guide.find(params[:guide_id])
  end
end
