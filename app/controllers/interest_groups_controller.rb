class InterestGroupsController < ApplicationController
  def index
    params[:subjects] ||= []
    @interest_groups =
      if params[:subjects].present?
        InterestGroup.for_subjects(params[:subjects]).paginate(:order => 'name', :page => params[:page])
      else
        @q = params[:q]
        InterestGroup.paginated_search(params).results
      end
    @subjects = Subject.tag_cloud_for_interest_groups_matching(@q).all(:limit => 25)

    respond_to do |format|
      format.html
      format.js {
        render 'interest_groups/index', :layout => false
      }
    end
  end

  def show
    @interest_group = InterestGroup.find(params[:id], :include => :subjects)
    if !@interest_group.friendly_id_status.best?
      redirect_to interest_group_path(@interest_group), :status => 301
      return
    end

    @report = @interest_group.report
    if @report
      @subjects = @report.subjects
      @scores = @report.scores.for_politicians(sought_politicians)
    end

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'reports/scores/table', :locals => {
          :report => @report, :scores => @scores
        }
      }
    end
  end
end
