class BillsController < ApplicationController
  def index
    if @q = params[:q]
      @title = 'Matching Bills'
      @bills = Bill.search { fulltext @q }.results
    else
      @title = 'Recent Bills'
      @bills = Bill.recent.paginate :page => params[:page], :per_page => 50
    end
  end

  def show
    @bill = Bill.fetch(params[:id])
  end
end
