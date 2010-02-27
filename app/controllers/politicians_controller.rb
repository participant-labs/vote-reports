class PoliticiansController < ApplicationController

  def index
    @politicians = Politician
    if params[:from_where].present?
      @politicians = @politicians.from(params[:from_where])
    end
    @politicians = @politicians.in_office(params[:in_office])

    @politicians = @politicians.by_birth_date.paginate(:page => params[:page])

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
    @terms = (
      @politician.representative_terms.all(:include => [:party, :district])  +
      @politician.senate_terms.all(:include => [:party, :state]) +
      @politician.presidential_terms.all(:include => :party)
    ).sort_by(&:ended_on).reverse
    per_page = Bill.per_page / 2
    @supported_bills = @politician.supported_bills.paginate(:page => params[:supported_page], :per_page => per_page, :include => {:titles => :as})
    @opposed_bills = @politician.opposed_bills.paginate(:page => params[:opposed_page], :per_page => per_page, :include => {:titles => :as})
  end

end
