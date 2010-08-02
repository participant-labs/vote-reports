class BillsController < ApplicationController
  def index
    if params[:term].present?
      @title = 'Matching Bills'
      @bills = Bill.paginated_search(params).results
    else
      @title = 'Recent Bills'
      @bills = Bill.by_introduced_on.paginate :page => (params[:bills_page] || params[:page]), :include => :titles
    end
    respond_to do |format|
      format.html
      format.js {
        render :partial => 'bills/list', :locals => {:bills => @bills}
      }
    end
  end

  def show
    @bill = Bill.find(params[:id], :include => [{:sponsor => :state}, :titles, :subjects, :amendments, :rolls, {:bill_criteria => {:report => :user}}])
    @rolls = @bill.rolls.by_voted_at
    @amendments_count = @bill.amendments.with_votes.count
    @reports = @bill.reports.published
  end
end
