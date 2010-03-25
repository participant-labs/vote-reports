class InterestGroupsController < ApplicationController
  def index
    params[:subjects] ||= []
    @interest_groups =
      if params[:subjects].present?
        InterestGroup.for_subjects(params[:subjects]).paginate(:page => params[:page])
      else
        @q = params[:q]
        InterestGroup.paginated_search(params).results
      end
    @subjects = Subject.for_interest_groups_tag_cloud_matching(@q).all(:limit => 25)

    respond_to do |format|
      format.html
      format.js {
        render 'interest_groups/index', :layout => false
      }
    end
  end

  def show
    @interest_group = InterestGroup.find(params[:id])
    @subjects = @interest_group.subjects
  end
end
