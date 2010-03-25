class InterestGroupsController < ApplicationController
  def index
    params[:subjects] ||= []
    @interest_groups = InterestGroup.for_subjects(params[:subjects]).paginate(:page => params[:page])
    @subjects = Subject.for_interest_groups_tag_cloud.scoped(:limit => 20)

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
