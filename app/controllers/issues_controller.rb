class IssuesController < ApplicationController
  def index
    @issues = Issue.paginate :page => params[:page]
  end

  def show
    @issue = Issue.find(params[:id])
    @causes = @issue.causes.paginate :page => params[:page]
  end

  def new
    params[:issue][:causes] = Cause.find(params[:causes]) if params[:causes].present?
    @issue = Issue.new(params[:issue])
    @causes = Cause.all

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'causes/list', :locals => {:causes => @issue.causes}
      }
    end
  end

  def create
    params[:issue][:causes] = Cause.find(params[:causes]) if params[:causes].present?
    @issue = Issue.new(params[:issue])
    if @issue.save
      flash[:notice] = "Issue Create"
      redirect_to issue_path(@issue)
    else
      flash[:notice] = "We had a problem"
      @causes = Cause.all
      render :action => :new
    end
  end
  
end
