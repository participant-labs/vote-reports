class BillsController < ApplicationController
  def index
    if @q = params[:q]
      @title = 'Matching Bills'
      @bills = Bill.fetch_by_query(@q)
    else
      @title = 'Recent Bills'
      @bills = Bill.recent
    end
  end

  def show
    @bill = Bill.fetch(params[:id])
  end
end
