class Subjects::ReportsController < ApplicationController
  def index
    @subject = Subject.find(params[:subject_id])
    @reports = @subject.reports.published.paginate :page => params[:page]
    render :layout => false
  end
end
