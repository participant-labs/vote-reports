class PoliticiansController < ApplicationController

  def index
    @politicians = sought_politicians.by_birth_date.paginate(:page => params[:page])

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'politicians/list', :locals => {
          :politicians => @politicians
        }
      }
    end
  end

  def show
    params[:subjects] ||= []

    @politician = Politician.find(params[:id],
      :include => [:state, {:report_scores => [:report, :evidence]}])
    if !@politician.friendly_id_status.best?
      redirect_to politician_path(@politician), :status => 301
      return
    end

    if params[:q].present?
      @reports = Report.paginated_search(params).results
      @scores = @reports.replace(topical_scores.for_reports(@reports).all(:include => :report))
    else
      @scores = topical_scores.paginate(:page => params[:page], :include => :report)
    end

    @subjects =  Subject.on_published_reports.for_tag_cloud.all(:limit => 20)

    respond_to do |format|
      format.html {
        @terms = @politician.terms
      }
      format.js {
        render :partial => 'politicians/scores/table', :locals => {
          :scores => @scores
        }
      }
    end
  end

  private

  def topical_scores
    @politician.report_scores.published.for_reports_with_subjects(params[:subjects])
  end
end
