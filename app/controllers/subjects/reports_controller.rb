class Subjects::ReportsController < ApplicationController
  def index
    @subject = Subject.find(params[:subject_id])
    @reports = @subject.reports.published.non_cause.for_display.paginate :page => params[:page], :order => 'reports.name'
    render :layout => false
  end
end
