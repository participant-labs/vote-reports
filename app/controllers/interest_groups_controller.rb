class InterestGroupsController < ApplicationController
  filter_resource_access

  def index
    params[:subjects] ||= []
    @interest_groups =
      if params[:term].present?
        InterestGroup.paginated_search(params).results
      else
        InterestGroup.for_subjects(params[:subjects]).paginate(:order => 'name', :page => params[:page])
      end
    @subjects = Subject.tag_cloud_for_interest_groups_matching(params[:term]).all(:limit => 25)

    respond_to do |format|
      format.html
      format.js {
        render 'interest_groups/index', :layout => false
      }
    end
  end

  def show
    if !@interest_group.friendly_id_status.best?
      redirect_to interest_group_path(@interest_group), :status => 301
      return
    end
  end

  def new
  end

  def create
    if @interest_group.save
      flash[:notice] = "Successfully created Interest Group"
      redirect_to @interest_group
    else
      flash[:error] = "Unable to create Interest Group"
      render :action => :new
    end
  end

  def new_interest_group_from_params
    @interest_group = InterestGroup.new((params[:interest_group] || {}).reject {|k, v| v.blank? })
  end
end
