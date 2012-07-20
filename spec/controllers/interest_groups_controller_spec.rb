require 'spec_helper'

describe InterestGroupsController do
  describe 'GET index' do
    let(:with_many_interest_groups) {
      35.times { create_interest_group }
    }

    context 'without arguments' do
      it 'shows the first page of interest groups' do
        with_many_interest_groups
        get :index
        assigns[:interest_groups].should == InterestGroup.order('name').page(1)
      end
    end
    context 'with a page' do
      it 'shows that page of interest groups' do
        with_many_interest_groups
        get :index, page: 2
        assigns[:interest_groups].should == InterestGroup.order('name').page(2)
      end
    end
    context 'with a term' do
      it 'shows interest groups matching the query'
    end
    context 'with a category' do
      it 'shows interest groups matching the categories'
    end
  end
end