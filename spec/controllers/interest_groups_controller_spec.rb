require 'spec_helper'

describe InterestGroupsController do
  describe 'GET index' do
    before do
      create_list(:interest_group, 35)
    end

    context 'without arguments' do
      it 'shows the first page of interest groups' do
        get :index
        expect(assigns[:interest_groups]).to eq(InterestGroup.order('name').page(1))
      end
    end
    context 'with a page' do
      it 'shows that page of interest groups' do
        get :index, page: 2
        expect(assigns[:interest_groups]).to eq(InterestGroup.order('name').page(2))
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
