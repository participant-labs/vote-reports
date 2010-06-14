class Users::ScoresController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @report = @user.personal_report
    @scores = @report.scores

    respond_to do |format|
      format.html
      format.js {
        render :layout => false
      }
    end
  end
end
