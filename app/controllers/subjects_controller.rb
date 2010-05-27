class SubjectsController < ApplicationController
  def index
    if params[:q].present?
      @title = 'Matching Subjects'
      @subjects = Subject.paginated_search(params).results
    else
      @title = 'Popular Subjects'
      @subjects = Subject.on_published_reports.for_tag_cloud.all(:limit => 80)
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
    if !@subject.friendly_id_status.best?
      redirect_to subject_path(@subject), :status => 301
      return
    end
    @bills = @subject.bills.paginate :page => params[:bill_page]
    @reports = @subject.reports.published.paginate :page => params[:report_page]
  end
end