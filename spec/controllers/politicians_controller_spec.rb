require File.dirname(__FILE__) + '/../spec_helper'

describe PoliticiansController do

  describe "routes" do
    route_matches("/politicians",   :get,   :controller => 'politicians', :action => 'index')
    route_matches("/politicians/1", :get,   :controller => 'politicians', :action => 'show', :id => '1')    
    it "should not support nested crud" do
      {:post=>"/politicians"}.should_not be_routable
      {:put => "/politicians/1"     }.should_not be_routable
      {:delete => "/politicians/1"  }.should_not be_routable
      {:get => "/politicians/1/edit"}.should_not be_routable
    end
  end

  describe "GET show" do
    context "when there is a better id for this report" do
      before do
        @politician = create_politician
      end

      it "should redirect" do
        get :show, :id => @politician
        response.should redirect_to(politician_path(@politician))
      end
    end
  end
end
