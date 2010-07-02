class Users::ScoresController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @user.personal_report || @user.rescore_personal_report
    @report = @user.personal_report
    @scores = @report.scores.for_politicians(sought_politicians)

    respond_to do |format|
      format.html {
        render :layout => false
      }
      format.js {
        render :partial => 'reports/scores/table', :locals => {
          :report => @report, :scores => @scores, :replace => 'report_scores',
          :reset_path => user_report_scores_path(@user, :representing => '') }
      }
    end
  end
end
