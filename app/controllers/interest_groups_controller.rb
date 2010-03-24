class InterestGroupsController < ApplicationController
  def index
    @interest_groups = InterestGroup.paginate(:page => params[:page])

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'interest_groups/list', :locals => {
          :interest_groups => @interest_groups
        }
      }
    end
  end
end
