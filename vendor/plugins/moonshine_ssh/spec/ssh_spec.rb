require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class SSHManifest < Moonshine::Manifest
  plugin :ssh
end

describe SSH do
  
  before do
    @manifest = SSHManifest.new
  end
  
  
  it "should be executable" do
    @manifest.should be_executable
  end
  
  it "should load the template file" do
    File.should_receive(:read).with(File.expand_path(File.join(File.dirname(__FILE__), '..', 'templates', 'sshd_config'))).and_return "SSH CONFIG"
    @manifest.ssh
  end
  
  it "should set default values" do
    @manifest.ssh
    @manifest.files.should include("/etc/ssh/sshd_config.new")
    sshd_config = @manifest.files["/etc/ssh/sshd_config.new"].content
    sshd_config.should match /Port 22/
    sshd_config.should match /PermitRootLogin no/
  end
  
  it "should check the configuration file before updating" do
    @manifest.ssh
    @manifest.execs.should include("cp /etc/ssh/sshd_config.new /etc/ssh/sshd_config")
    @manifest.execs["cp /etc/ssh/sshd_config.new /etc/ssh/sshd_config"].onlyif.should match /sshd -t/
  end

  it "should allow customization" do
    @manifest.ssh( :port => 9022 )
    @manifest.files["/etc/ssh/sshd_config.new"].content.should match /Port 9022/
  end
  
  describe "configured for sftponly" do
    
    before do
      @manifest.ssh(:sftponly => {
        :users => {
          :rob => {
            :password => 'sekrit',
            :groups => 'rails'
          }
        }
      })
    end
    
    it "should create the sftponly group" do
      @manifest.groups.should include('sftponly')
    end
    
    it "should add the user" do
      @manifest.users.should include('rob')
      @manifest.execs['rob password'].command.should == "echo rob:sekrit | chpasswd"
    end
    
    it "should add user to sftponly and extra groups if requested" do
      @manifest.users['rob'].groups.should == ['sftponly','rails']
    end
    
    it "should create the home directory" do
      @manifest.files.should include('/home/rob/home/rob')
      @manifest.files['/home/rob/home/rob'].owner.should == 'rob'
      @manifest.files['/home/rob/home'].owner.should == 'root'
      @manifest.files['/home/rob'].owner.should == 'root'
    end
   
    it "should set the sftp subsystem" do
      @manifest.files['/etc/ssh/sshd_config.new'].content.should match /Subsystem sftp internal-sftp/
    end
   
    it "should add a group matcher to the sshd config" do
      @manifest.files['/etc/ssh/sshd_config.new'].content.should match /Match Group sftponly/
      @manifest.files['/etc/ssh/sshd_config.new'].content.should match /ChrootDirectory \/home\/%u/
    end
    
  end
    
end