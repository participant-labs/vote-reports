shared_context 'as an admin' do
  let(:admin) {
    user = create(:user)
    user.create_adminship!(created_by: user)
    user
  }

  before do
    login admin
  end
end

shared_examples_for 'denies user' do
  context "as a user" do
    it "denies access" do
      login
      send_request
      flash[:error].should == 'You may not access this page'
      response.redirect_url.should match(%r{^http://test.host#{root_path}(\?|$)})
    end
  end
end

shared_examples_for 'denies visitor' do
  context "as a visitor" do
    it "denies access" do
      send_request
      flash[:notice].should == 'You must be logged in to access this page'
      response.redirect_url.should match(%r{^http://test.host#{login_path}(\?|$)})
    end
  end
end
