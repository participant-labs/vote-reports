require File.dirname(__FILE__) + '/../spec_helper'
 
describe UsersController do


  describe "route recognition" do
    
    it "should route the signup route correctly" do
      params_from(:get, '/signup').should == {:controller => 'users', :action => 'new'}
    end

  end
  
end
