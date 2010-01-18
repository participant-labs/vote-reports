class PoliticiansController < ApplicationController

  def index
    @politicians = Politician.all
  end

  def show
    @politician = Politician.find(params[:id], :include => {:politician_terms => :party})
    if @politician.has_better_id?
      redirect_to politician_path(@politician), :status => 301
    end
    per_page = Bill.per_page / 2
    @supported_bills = @politician.supported_bills.paginate(:page => params[:supported_page], :per_page => per_page, :include => :titles)
    @opposed_bills = @politician.opposed_bills.paginate(:page => params[:opposed_page], :per_page => per_page, :include => :titles)
  end

end
