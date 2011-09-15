class Politicians::CausesController < ApplicationController
  def index
    @politician = Politician.find(params[:politician_id])
    @scores = @politician.report_scores.for_causes.for_politician_display.page(params[:page])
    respond_to do |format|
      format.html {
        render layout: false
      }
      format.js {
        render partial: 'politicians/scores/table',
          locals: {scores: @scores, id: 'cause_scores', replace: 'cause_scores', source: 'Cause'}
      }
    end
  end
end
