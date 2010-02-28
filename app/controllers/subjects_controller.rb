class SubjectsController < ApplicationController
  def index
    if @q = params[:q]
      @title = 'Matching Subjects'
      @subjects = Subject.paginated_search(params).results
    else
      @title = 'Popular Subjects'
      @subjects = Subject.for_report(Report.published).for_tag_cloud.scoped(:limit => 80)
    end

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'subjects/list', :locals => {
          :subjects => @subjects, :title => @title
        }
      }
    end
  end

  def show
    @subject = Subject.find(params[:id])
    @bills = @subject.bills.paginate :page => params[:bill_page]
    @reports = @subject.reports.paginate :page => params[:report_page]
  end
end