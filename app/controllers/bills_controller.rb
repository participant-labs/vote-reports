class BillsController < ApplicationController
  def index
    if @q = params[:q]
      @bills = Bill.find_by_query(@q)
    end
  end

  def show
    @bill = Bill.find(params[:id])
  end
end
