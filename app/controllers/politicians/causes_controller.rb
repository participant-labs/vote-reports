class Politicians::CausesController < ApplicationController
  def index
    @politician = Politician.find(params[:politician_id])
    @scores = @politician.report_scores.for_causes.paginate :page => params[:page]
    render :layout => false
  end
end
