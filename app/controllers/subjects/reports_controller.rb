class Subjects::ReportsController < ApplicationController
  def index
    @subject = Subject.find(params[:subject_id])
    @reports = @subject.reports.published.non_cause.for_display.order('reports.name').page(params[:page])
    render layout: false
  end
end
