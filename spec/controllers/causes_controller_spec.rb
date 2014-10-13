require 'rails_helper'

RSpec.describe CausesController do
  setup :activate_authlogic

  describe 'GET index' do
    before(:all) {
      create_list(:cause, 35)
    }
    context 'without params' do
      it 'shows the first page of causes' do
        get :index
        expect(assigns[:causes]).to eq(Cause.order(:name).page(1))
      end
    end
    context 'with a page' do
      it 'shows that page of causes' do
        get :index, page: 2
        expect(assigns[:causes]).to eq(Cause.order(:name).page(2))
      end
    end
  end

  describe 'POST create' do
    def send_request
      post :create, cause: {
        name: 'My favorite cause',
        description: 'Why do I like it so much? It boggles the mind.'}
    end

    it_behaves_like 'denies user'
    it_behaves_like 'denies visitor'

    context 'as an admin', :admin do
      it 'creates the cause' do
        expect {
          send_request
        }.to change(Cause, :count).by(1)
        expect(assigns[:cause].name).to eq('My favorite cause')
        expect(assigns[:cause].description).to eq(
          'Why do I like it so much? It boggles the mind.'
        )
      end

      it 'sends me to the cause page' do
        send_request
        expect(response).to redirect_to(cause_path(assigns[:cause]))
      end
    end
  end

  describe 'PUT update' do
    let(:cause) { create(:cause, name: 'Trade is Awesome') }
    let(:new_name) { 'International Trade is Awesome' }

    def send_request
      put :update, id: cause, cause: {name: new_name}
    end

    it_behaves_like 'denies user'
    it_behaves_like 'denies visitor'

    context 'as an admin', :admin do
      it 'updates the cause' do
        send_request
        expect(assigns[:cause].name).to eq(new_name)
      end

      it 'sends me to the cause page' do
        send_request
        expect(response).to redirect_to(cause_path(assigns[:cause]))
      end
    end
  end
end
