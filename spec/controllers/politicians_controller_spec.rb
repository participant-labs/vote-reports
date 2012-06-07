require File.dirname(__FILE__) + '/../spec_helper'

describe PoliticiansController do
  setup :activate_authlogic

  describe "routes" do
    route_matches("/politicians",   :get,   controller: 'politicians', action: 'index')
    route_matches("/politicians/1", :get,   controller: 'politicians', action: 'show', id: '1')    
    it "should not support nested crud" do
      {:post=>"/politicians"}.should_not be_routable
      {put: "/politicians/1"     }.should_not be_routable
      {delete: "/politicians/1"  }.should_not be_routable
      {get: "/politicians/1/edit"}.should_not be_routable
    end
  end

  describe "GET index" do
    let(:has_many_politicians) { 35.times { create_politician } }

    context 'without params' do
      it 'shows the first page of politicians' do
        has_many_politicians
        get :index
        assigns[:politicians].should == Politician.scoreworthy.by_birth_date.page(1)
      end
    end

    context 'with a page param' do
      it 'shows that page of politicians' do
        has_many_politicians
        get :index, page: 2
        assigns[:politicians].should == Politician.scoreworthy.by_birth_date.page(2)
      end
    end
  end

  describe "GET show" do
    context "when there is a better id for this report" do
      let(:politician) { create_politician }

      it "should redirect" do
        get :show, id: politician.id
        response.should redirect_to(politician_path(politician))
      end
    end
  end
end
