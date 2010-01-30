class Users::ReportsController < ApplicationController
  before_filter :is_report_owner, :except => [:index, :show]

  def index
    @user = User.find(params[:user_id])
    @reports = @user.reports
  end

  def show
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:id], :scope => @user, :include => {
      :user => nil,
      :bill_criteria => {
        :bill => [{:titles => :as}, :congress, :passage_rolls]
      }
    })
    if @report.has_better_id?
      redirect_to user_report_path(@user, @report), :status => 301
      return
    end
    score_count = (@report.scores.count + 1) / 2
    @top_scores = @report.scores.with_evidence.paginate(:page => params[:top_page],
      :total_entries => score_count)
    @bottom_scores = @report.scores.with_evidence.paginate(:page => params[:bottom_page],
      :total_entries => score_count,
      :order => :score)

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'reports/scores/table', :locals => {
          :report => @report, :top_scores => @top_scores, :bottom_scores => @bottom_scores
        }
      }
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:id], :scope => @user)
    if @report.has_better_id?
      redirect_to edit_user_report_path(@user, @report), :status => 301
    end
  end

  def update
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:id], :scope => @user)
    if @report.update_attributes(params[:report])
      flash[:notice] = "Successfully updated report."
      redirect_to [@user, @report]
    else
      render :action => 'edit'
    end
  end

  def new
    @user = User.find(params[:user_id])
    @report = @user.reports.build
  end

  def create
    @user = User.find(params[:user_id])
    @report = @user.reports.build(params[:report])
    if @report.save
      flash[:notice] = "Successfully created report."
      redirect_to new_user_report_bills_path(@user, @report)
    else
      render :action => 'new'
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @user.reports.find(params[:id], :scope => @user).destroy
    flash[:notice] = "Successfully destroyed report."
    redirect_to user_reports_url(@user)
  end
end
