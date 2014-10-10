require 'spec_helper'

describe InterestGroups::ClaimsController do
  let(:interest_group) { create(:interest_group) }

  describe 'GET new' do
    render_views

    it 'succeeds' do
      get :new, interest_group_id: interest_group
      expect(response.body).to include('just send us an email send us an email at')
    end
  end
end
