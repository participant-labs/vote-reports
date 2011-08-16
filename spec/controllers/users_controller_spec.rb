require File.dirname(__FILE__) + '/../spec_helper'
 
describe UsersController do

  describe "route recognition" do
    it "should route the signup route correctly" do
      {:get => '/signup'}.should route_to(:controller => 'users', :action => 'new')
      {:get => '/users/new'}.should route_to(:controller => 'users', :action => 'new')
    end

    it "should route to a single user correctly" do
      {:get => '/users/empact'}.should route_to(:controller => 'users', :action => 'show', :id => 'empact')
    end

  end

  describe "GET index" do
    it "should reject me if I'm not logged in" do
      get :index
      flash[:notice].should == "You must be logged in to access this page"
      response.should redirect_to(login_url(:return_to => '/users'))
    end

    it "should reject me if I'm not an admin" do
      login
      get :index
      flash[:error].should == "You may not access this page"
      response.should redirect_to(root_path)
    end
  end

  describe "GET edit" do
    before do
      @user = create_user
    end

    it "should reject me if I'm not logged in" do
      logout
      get :edit, :id => @user
      response.should redirect_to(login_url(:return_to => %Q{/users/#{@user.to_param}/edit}))
      flash[:notice].should == "You must be logged in to access this page"
    end

    it "should reject me if I'm not the user being edited" do
      current = create_user
      login(current)
      get :edit, :id => @user
      response.should redirect_to(user_reports_url(@user))
      flash[:error].should == "You may not access this page"
    end
  end
end
