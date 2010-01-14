class PoliticiansController < ApplicationController

  def index
    @politicians = Politician.all
  end

  def show
    @politician = Politician.find(params[:id])
    if @politician.has_better_id?
      redirect_to politician_path(@politician), :status => 301
    end
    per_page = Bill.per_page / 2
    @supported_bills = @politician.bills.supported.paginate(:page => params[:supported_page], :per_page => per_page)
    @opposed_bills = @politician.bills.opposed.paginate(:page => params[:opposed_page], :per_page => per_page)
  end

end
