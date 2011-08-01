class PoliticiansController < ApplicationController

  def index
    @politicians = sought_politicians.by_birth_date.page(params[:page])

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'politicians/list', :locals => {
          :politicians => @politicians
        }
      }
    end
  end

  def show
    @politician = Politician.for_display.find(params[:id])
    if !@politician.friendly_id_status.best?
      redirect_to politician_path(@politician), :status => 301
      return
    end
    @terms = @politician.continuous_terms
  end

  private

  def topical_scores
    @politician.report_scores.published.for_reports_with_subjects(params[:subjects])
  end
end
