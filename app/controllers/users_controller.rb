class UsersController < ApplicationController
  filter_resource_access

  def index
    @users = User.all
  end

  def show
    @reports = @user.reports
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html
      format.js {
        render :layout => false
      }
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Thanks for signing up. Welcome to VoteReports."
      redirect_to @user
    else
      render :action => 'new'
    end
  end

  def edit
    @user.valid?
    @new_user = true if params[:new_user]
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to users_path
  end

  private

  def permission_denied_path
    if params[:id]
      user_reports_path(params[:id])
    else
      root_path
    end
  end
end
