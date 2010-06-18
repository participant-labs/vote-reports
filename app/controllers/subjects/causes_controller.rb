class Subjects::CausesController < ApplicationController
  def index
    @subject = Subject.find(params[:subject_id])
    @reports = @subject.reports.published.for_causes.paginate :page => params[:page], :order => 'reports.name'
    render :layout => false
  end
end
