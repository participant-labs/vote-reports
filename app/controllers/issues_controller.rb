class IssuesController < ApplicationController
  filter_resource_access

  def index
    @issues = Issue.page(params[:page])
  end

  def show
    @issue = Issue.find(params[:id])
    @causes = @issue.causes.page(params[:page])
  end

  def new
    @causes = Cause.without_issue

    respond_to do |format|
      format.html
      format.js {
        render partial: 'causes/list', locals: {causes: @issue.causes}
      }
    end
  end

  def create
    @issue = Issue.new(issue_params)
    if @issue.save
      flash[:notice] = "Issue Create"
      redirect_to issue_path(@issue)
    else
      flash[:notice] = "We had a problem"
      @causes = Cause.all
      render action: :new
    end
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    flash[:notice] = "Issue destroyed"
    redirect_to action: :index
  end

  protected

  def new_issue_from_params
    @issue = Issue.new(issue_params)
  end

  private

  def issue_params
    ps = params.require(:issue).permit(:title)
    if params[:causes].present?
      ps[:causes] = Cause.where(slug: params[:causes])
    end
    ps
  end
end
