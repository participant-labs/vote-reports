class BillsController < ApplicationController
  def index
    if @q = params[:q]
      @bills = []
    end
  end
end
