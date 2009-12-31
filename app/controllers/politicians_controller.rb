class PoliticiansController < ApplicationController

  def index
    @politicians = Politician.all
  end

  def show
    @politician = Politician.find(params[:id])
    if @politician.has_better_id?
      redirect_to politician_path(@politician), :status => 301
    end
  end

end
