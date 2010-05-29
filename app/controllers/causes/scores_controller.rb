class Causes::ScoresController < ApplicationController
  filter_access_to :all
  before_filter :load_cause

  def index
    @report = @cause.report
    @scores = @report.scores.for_politicians(sought_politicians)
    respond_to do |format|
      format.js {
        render :layout => false
      }
    end
  end

  def show
    @report = @cause.report
    @score = @report.scores.find(params[:id])
    respond_to do |format|
      format.js {
        render :layout => false
      }
    end
  end

  private

  def load_cause
    @cause = Cause.find(params[:cause_id])
  end
end
