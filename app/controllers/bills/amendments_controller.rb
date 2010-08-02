class Bills::AmendmentsController < ApplicationController
  before_filter :load_bill
  layout nil

  def index
    @amendments = @bill.amendments.with_votes.by_offered_on
  end

  def show
    @amendment = @bill.amendments.find(params[:id])
    @rolls = @amendment.rolls.by_voted_at
  end

  private

  def load_bill
    @bill = Bill.find params[:bill_id]
  end
end
