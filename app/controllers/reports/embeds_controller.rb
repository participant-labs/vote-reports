class Reports::EmbedsController < ApplicationController
  before_filter :load_report
  layout 'minimal'

  def show
    @scores = @report.scores.for_politicians(sought_politicians).paginate :page => params[:page], :per_page => 3

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'reports/embeds/scores',
          :locals => {:scores => @scores, :replace => 'embeded_report_scores'}
      }
    end
  end

  private

  def load_report
    @report = User.find(params[:user_id]).reports.find(params[:report_id])
  end
end
