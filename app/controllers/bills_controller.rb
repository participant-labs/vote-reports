class BillsController < ApplicationController
  def index
    if @q = params[:q]
      @bills = Bill.fetch_by_query(@q)
    end
  end

  def show
    @bill = Bill.fetch(params[:id])
  end
end
