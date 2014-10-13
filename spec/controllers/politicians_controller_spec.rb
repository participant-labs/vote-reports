require 'rails_helper'

RSpec.describe PoliticiansController do
  setup :activate_authlogic

  describe "GET index" do
    let(:has_many_politicians) { create_list(:politician, 35) }

    context 'without params' do
      it 'shows the first page of politicians' do
        has_many_politicians
        get :index
        expect(assigns[:politicians]).to eq(Politician.scoreworthy.by_birth_date.page(1))
      end
    end

    context 'with a page param' do
      it 'shows that page of politicians' do
        has_many_politicians
        get :index, page: 2
        expect(assigns[:politicians]).to eq(Politician.scoreworthy.by_birth_date.page(2))
      end
    end
  end

  describe "GET show" do
    context "when there is a better id for this report" do
      let(:politician) { create(:politician) }

      it "should redirect" do
        get :show, id: politician.id
        expect(response).to redirect_to(politician_path(politician))
      end
    end
  end
end
