class Subjects::ReportsController < ApplicationController
  def index
    @subject = Subject.find(params[:subject_id])
    @reports = @subject.reports.published.non_cause.paginate :page => params[:page], :order => 'reports.name'
    render :layout => false
  end
end
