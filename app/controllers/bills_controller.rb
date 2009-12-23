class BillsController < ApplicationController
  def index
    if @q = params[:q]
      @title = 'Matching Bills'
      @bills = Bill.paginated_search(params).results
    else
      @title = 'Recent Bills'
      @bills = Bill.recent.paginate :page => params[:page], :per_page => Bill::PER_PAGE
    end
  end

  def show
    @bill = Bill.find(params[:id])
  end
end
