class Users::Reports::ScoresController < ApplicationController
  before_filter :load_report

  def index
    @scores = @report.scores.for_politicians(sought_politicians).by_score
    respond_to do |format|
      format.json {
        render json: @report.as_json.merge(scores: @report.scores.as_json)
      }
    end
  end

  def show
    @score = @report.scores.find(params[:id])
    respond_to do |format|
      format.html
      format.js {
        render layout: false
      }
    end
  end

  private

  def load_report
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:report_id])
  end
end
