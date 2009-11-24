class PoliticiansController < ApplicationController

  def index
    @politicians = Politician.all
  end

  def show
    @politicians = Politician.find(params[:id])
  end

end
