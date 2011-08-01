class Subjects::CausesController < ApplicationController
  def index
    @subject = Subject.find(params[:subject_id])
    @reports = @subject.reports.published.for_causes.order('reports.name').page(params[:page])
    render :layout => false
  end
end
