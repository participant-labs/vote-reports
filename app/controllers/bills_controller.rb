class BillsController < ApplicationController
  def index
    if @q = params[:q]
      @title = 'Matching Bills'
      @bills = Bill.paginated_search(params).results
    else
      @title = 'Recent Bills'
      @bills = Bill.by_introduced_on.paginate :page => params[:page], :include => :titles
    end
  end

  def show
    @bill = Bill.find(params[:id], :include => [{:sponsor => :state}, :titles, :amendments, :rolls, {:bill_criteria => {:report => :user}}])
    @titles =  @bill.titles
    @rolls = @bill.rolls.by_voted_at
  end
end
