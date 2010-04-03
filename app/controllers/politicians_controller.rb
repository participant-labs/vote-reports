class PoliticiansController < ApplicationController

  def index
    @politicians = sought_politicians.by_birth_date.paginate(:page => params[:page])

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
    @politician = Politician.find(params[:id],
      :include => [:state, {:report_scores => [:report, :evidence]}])
    if !@politician.friendly_id_status.best?
      redirect_to politician_path(@politician), :status => 301
      return
    end
    @scores = @politician.report_scores.published.paginate(:page => params[:page])

    respond_to do |format|
      format.html {
        @terms = (
          @politician.representative_terms.all(:include => [:party, :district])  +
          @politician.senate_terms.all(:include => [:party, :state]) +
          @politician.presidential_terms.all(:include => :party)
        ).sort_by(&:ended_on).reverse
      }
      format.js {
        render :partial => 'politicians/scores/table', :locals => {
          :scores => @scores
        }
      }
    end
  end

end
