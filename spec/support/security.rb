RSpec.shared_context 'as an admin', :admin do
  let(:admin) {
    user = create(:user)
    user.create_adminship!(created_by: user)
    user
  }

  before do
    login admin
  end
end

RSpec.shared_examples_for 'denies user' do
  context "as a user" do
    it "denies access" do
      login
      send_request
      expect(flash[:error]).to eq('You may not access this page')
      expect(response.redirect_url).to match(%r{^http://test.host#{root_path}(\?|$)})
    end
  end
end

RSpec.shared_examples_for 'denies visitor' do
  context "as a visitor" do
    it "denies access" do
      send_request
      expect(flash[:notice]).to eq('You must be logged in to access this page')
      expect(response.redirect_url).to match(%r{^http://test.host#{login_path}(\?|$)})
    end
  end
end
