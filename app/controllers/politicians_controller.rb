class PoliticiansController < ApplicationController

  def index
    @politicians = Politician.by_birth_date.paginate(:page => params[:page])
  end

  def show
    @politician = Politician.find(params[:id], :include => :state)
    if @politician.has_better_id?
      redirect_to politician_path(@politician), :status => 301
    end
    @terms = @politician.terms.by_ended_on.all(:include => [:party, :state])
    per_page = Bill.per_page / 2
    @supported_bills = @politician.supported_bills.paginate(:page => params[:supported_page], :per_page => per_page, :include => {:titles => :as})
    @opposed_bills = @politician.opposed_bills.paginate(:page => params[:opposed_page], :per_page => per_page, :include => {:titles => :as})
  end

end
