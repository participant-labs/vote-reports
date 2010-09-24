class Causes::ScoresController < ApplicationController
  filter_access_to :all
  before_filter :load_cause

  def index
    if !@cause.friendly_id_status.best?
      redirect_to cause_report_scores_path(@cause), :status => 301
      return
    end

    @report = @cause.report
    @scores = @report.scores.for_politicians(sought_politicians)
    respond_to do |format|
      format.html {
        render :layout => false
      }
      format.js {
        render :partial => 'reports/scores/table', :locals => {
          :report => @report, :scores => @scores, :replace => 'scores', :target_path => cause_report_scores_path(@cause)
        }
      }
      format.json {
        render :json => @report.scores
      }
    end
  end

  def show
    @report = @cause.report
    @score = @report.scores.find(params[:id])
    respond_to do |format|
      format.html
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
