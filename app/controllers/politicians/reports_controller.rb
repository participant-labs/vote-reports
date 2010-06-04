class Politicians::ReportsController < ApplicationController
  def index
    @politician = Politician.find(params[:politician_id])

    params[:subjects] ||= []
    if params[:term].present?
      @reports = Report.paginated_search(params).results
      @scores = @reports.replace(topical_scores.for_reports(@reports).all(:include => :report))
    else
      @scores = topical_scores.paginate(:page => params[:page], :include => :report)
    end

    @subjects = Subject.for_report(@scores.map(&:report)).for_tag_cloud.all(:limit => 20)

    render :partial => 'politicians/scores/table', :locals => {:scores => @scores}
  end

  private

  def topical_scores
    @politician.report_scores.published.for_reports_with_subjects(params[:subjects])
  end
end