class BillsController < ApplicationController
  def index
    page = {:page => params[:page], :per_page => Bill::PER_PAGE}
    if @q = q = params[:q]
      @title = 'Matching Bills'
      @bills = Bill.search {
        fulltext q
        paginate page
      }.results
    else
      @title = 'Recent Bills'
      @bills = Bill.recent.paginate page
    end
  end

  def show
    @bill = Bill.find(params[:id])
  end
end
