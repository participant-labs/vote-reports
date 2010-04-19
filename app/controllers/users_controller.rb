class UsersController < ApplicationController
  before_filter :is_admin?, :only => [:index, :destroy]
  before_filter :is_current_user?, :only => [:edit, :update]
  filter_resource_access

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @reports = @user.reports
    redirect_to [@user, :reports] unless current_user == @user
  end

  def new
    @user = User.new
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
    @user = User.find(params[:id])
    @user.valid?
    @new_user = true if params[:new_user]
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to users_url
  end
end
