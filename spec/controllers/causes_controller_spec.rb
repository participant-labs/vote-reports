require 'spec_helper'

describe CausesController do
  setup :activate_authlogic

  describe 'GET index' do
    let(:with_many_causes) {
      35.times { create(:cause) }
    }
    context 'without params' do
      it 'shows the first page of causes' do
        with_many_causes
        get :index
        assigns[:causes].should == Cause.order(:name).page(1)
      end
    end
    context 'with a page' do
      it 'shows that page of causes' do
        with_many_causes
        get :index, page: 2
        assigns[:causes].should == Cause.order(:name).page(2)
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

    context 'as an admin' do
      include_context 'as an admin'

      it 'creates the cause' do
        expect {
          send_request
        }.to change(Cause, :count).by(1)
        assigns[:cause].name == 'My favorite cause'
        assigns[:cause].description ==
          'Why do I like it so much? It boggles the mind.'
      end

      it 'sends me to the cause page' do
        send_request
        response.should redirect_to(cause_path(assigns[:cause]))
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

    context 'as an admin' do
      include_context 'as an admin'

      it 'updates the cause' do
        send_request
        assigns[:cause].name.should == new_name
      end

      it 'sends me to the cause page' do
        send_request
        response.should redirect_to(cause_path(assigns[:cause]))
      end
    end
  end
end
