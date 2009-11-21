class BillsController < ApplicationController
  def index
    if @q = params[:q]
      @bills = Bill.find(@q)
    end
  end
end
