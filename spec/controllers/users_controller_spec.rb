require File.dirname(__FILE__) + '/../spec_helper'
 
describe UsersController do

  describe "route recognition" do

    it "should route the signup route correctly" do
      params_from(:get, '/signup').should == {:controller => 'users', :action => 'new'}
      params_from(:get, '/users/new').should == {:controller => 'users', :action => 'new'}
    end

    it "should route to a single user correctly" do
      params_from(:get, '/users/empact').should == {:controller => 'users', :action => 'show', :id => 'empact'}
    end

  end
end
