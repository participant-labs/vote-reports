class Bills::AmendmentsController < ApplicationController
  before_filter :load_bill

  def index
    @amendments = @bill.amendments.with_votes.by_offered_on
    render :layout => false
  end

  def show
    @amendment = @bill.amendments.find(params[:id])
    @rolls = @amendment.rolls.by_voted_at

    respond_to do |format|
      format.html
      format.js {
        render :layout => false
      }
    end
  end

  private

  def load_bill
    @bill = Bill.find params[:bill_id]
  end
end
