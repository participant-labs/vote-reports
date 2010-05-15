require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class DenyhostsManifest < Moonshine::Manifest
  plugin :denyhosts
end

describe "A manifest with the Denyhosts plugin" do

  before do
    @manifest = DenyhostsManifest.new
    @manifest.denyhosts
  end

  it "should be executable" do
    @manifest.should be_executable
  end

end
