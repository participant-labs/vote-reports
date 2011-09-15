class Bills::TitlesController < ApplicationController
  def show
    @bill = Bill.find(params[:bill_id], include: :titles)
    render partial: 'bills/titles', locals: {bill: @bill}
  end
end
