require File.dirname(__FILE__) + '/../spec_helper'
 
describe UserSessionsController do


  describe "route recognition" do
    
    it "should route the login route correctly" do
      params_from(:get, '/login').should == {:controller => 'user_sessions', :action => 'new'}
    end
    it "should route the logout route correctly" do
      params_from(:get, '/logout').should == {:controller => 'user_sessions', :action => 'destroy'}
    end

  end
  
  
end
