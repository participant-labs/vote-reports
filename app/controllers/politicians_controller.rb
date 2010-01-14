class PoliticiansController < ApplicationController

  def index
    @politicians = Politician.all
  end

  def show
    @politician = Politician.find(params[:id])
    if @politician.has_better_id?
      redirect_to politician_path(@politician), :status => 301
    end
    @supported_bills = @politician.bills.supported.paginate(:page => params[:supported_page])
    @opposed_bills = @politician.bills.opposed.paginate(:page => params[:opposed_page])
  end

end
