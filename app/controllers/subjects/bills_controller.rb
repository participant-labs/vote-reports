class Subjects::BillsController < ApplicationController
  def index
    @subject = Subject.find(params[:subject_id])
    @bills = @subject.bills.paginate :page => params[:page]
    render :layout => false
  end
end
