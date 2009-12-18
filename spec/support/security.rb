def requires_login_for(method, action, *args)
  describe "in the name of security" do
    before(:each) { send(method, action, *args) }
    it_denies_access
  end
end

def it_denies_access(opts = {})
  flash_msg = opts[:flash] || /You must be logged in to access this page/
  redirect_path = opts[:redirect] || "login_path"

  it "sets the flash to #{flash_msg.inspect}" do
    flash[:notice].should match(flash_msg)
  end

  it "redirects to #{redirect_path}" do
    response.should be_redirect
    response.redirect_url.should match(%r{^http://test.host#{eval(redirect_path)}(\?|$)})
  end
end