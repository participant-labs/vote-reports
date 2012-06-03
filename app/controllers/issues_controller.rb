class IssuesController < ApplicationController
  filter_resource_access
  before_filter :prepare_causes, only: [:new, :create]

  def index
    @issues = Issue.page(params[:page])
  end

  def show
    @issue = Issue.find(params[:id])
    @causes = @issue.causes.page(params[:page])
  end

  def new
    @issue = Issue.new(params[:issue])
    @causes = Cause.without_issue

    respond_to do |format|
      format.html
      format.js {
        render partial: 'causes/list', locals: {causes: @issue.causes}
      }
    end
  end

  def create
    @issue = Issue.new(params[:issue])
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

  private

  def prepare_causes
    if params[:causes].present?
      params[:issue][:causes] = Cause.where(slug: params[:causes])
    end
  end
end
