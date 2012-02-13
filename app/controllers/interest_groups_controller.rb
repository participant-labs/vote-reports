class InterestGroupsController < ApplicationController
  filter_resource_access
  cache_sweeper :interest_group_sweeper, only: [:create, :update]

  def index
    params[:subjects] ||= []
    @interest_groups =
      if params[:term].present?
        InterestGroup.paginated_search(params)
      else
        InterestGroup.for_subjects(params[:subjects]).order('name').page(params[:page])
      end
    @subjects = Subject.tag_cloud_for_interest_groups_matching(params[:term]).all(limit: 25)

    respond_to do |format|
      format.html
      format.js {
        render 'interest_groups/index', layout: false
      }
      format.json {
        render json: @interest_groups
      }
    end
  end

  def show
    @subjects = @interest_group.subjects.for_tag_cloud.all(
      select: "DISTINCT(subjects.*), SUM(report_subjects.count) AS count",
      limit: 3)
    @scores = @interest_group.scores.for_politicians(sought_politicians).for_report_display
    respond_to do |format|
      format.html {
        unless request.path.start_with?(interest_group_path(@interest_group))
          redirect_to interest_group_path(@interest_group), status: 301
          return
        end
        @causes = @interest_group.causes.all(limit: 3)
      }
      format.js {
        render partial: 'reports/scores/table', locals: {
          report: @interest_group.report, scores: @scores, target_path: interest_group_path(@interest_group)
        }
      }
      format.json {
        render json: @interest_group.as_json.merge(subject: @subjects, causes: @interest_group.causes)
      }
    end
  end

  def new
  end

  def create
    if @interest_group.save
      flash[:notice] = "Successfully created interest group"
      redirect_to @interest_group
    else
      flash[:error] = "Unable to create interest group"
      render action: :new
    end
  end

  def edit
  end

  def update
    #protect ig from nils.. (shouldn't rails do this?)
    params[:interest_group].each_pair {|k, v| params[:interest_group][k] = nil if v.blank? }

    if params[:report].present? && @interest_group.report.update_attributes(params[:report])
      flash[:notice] = "Successfully updated interest group"
      redirect_to @interest_group
    elsif @interest_group.update_attributes(params[:interest_group])
      flash[:notice] = "Successfully updated interest group"
      redirect_to @interest_group
    else
      flash[:error] = "Unable to update interest group"
      render action: :edit
    end
  end

  def destroy
    @interest_group.destroy
    flash[:notice] = "Successfully deleted interest group"
    redirect_to interest_groups_path
  end

  protected

  def new_interest_group_from_params
    @interest_group = InterestGroup.new((params[:interest_group] || {}).reject {|k, v| v.blank? })
  end
end
