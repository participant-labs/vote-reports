class InterestGroups::SubjectsController < ApplicationController
  def index
    @interest_group = InterestGroup.find(params[:interest_group_id], :include => {:report => :subjects})
    @report = @interest_group.report
    @subjects = @report.subjects
    render :layout => false
  end
end
