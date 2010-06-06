class Politicians::CausesController < ApplicationController
  def index
    @politician = Politician.find(params[:politician_id])
    @scores = @politician.report_scores.for_causes.paginate :page => params[:page]
    respond_to do |format|
      format.html {
        render :layout => false
      }
      format.js {
        render :partial => 'politicians/scores/table',
          :locals => {:scores => @scores, :replace => 'report_scores', :source => 'Cause'}
      }
  end
end
