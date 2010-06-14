class Users::ScoresController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @report = @user.personal_report
    @scores = @report.scores
  end
end
