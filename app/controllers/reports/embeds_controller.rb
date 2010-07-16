class Reports::EmbedsController < ApplicationController
  before_filter :load_report
  layout nil

  def show
    @scores = @report.scores.for_politicians(sought_politicians).paginate :page => params[:page], :per_page => 3

    if params[:page]
      render :partial => 'reports/embeds/scores',
        :locals => {:scores => @scores, :replace => 'embeded_report_scores'}
    else
      render :js => %{document.write(#{ render_to_string(:action => 'show').to_json });}
    end
  end

  private

  def load_report
    @report = User.find(params[:user_id]).reports.find(params[:report_id])
  end
end
