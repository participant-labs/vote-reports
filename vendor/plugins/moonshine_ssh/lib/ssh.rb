module SSH

  # Ensures the SSH server is installed, running, and configured
  # per specifications. Use <tt>configure</tt> to change defaults.
  # The available options can be gathered by perusing the sshd_config
  # template.
  #
  #   configure(:ssh => {:permit_root_login => 'yes', :port => 9022})
  #
  def ssh(options = {})

    package 'ssh', :ensure => :installed
    service 'ssh', :enable => true, :ensure => :running

    if options[:sftponly]
      options[:subsystem] = {:sftp => 'internal-sftp'}
      sftponly(options[:sftponly])
    end

    file '/etc/ssh/sshd_config.new',
      :mode => '644',
      :content => template(File.join(File.dirname(__FILE__), '..', 'templates', 'sshd_config'), binding),
      :require => package('ssh'),
      :notify => exec('update_sshd_config')

    exec 'cp /etc/ssh/sshd_config.new /etc/ssh/sshd_config',
      :alias => 'update_sshd_config',
      :onlyif => '/usr/sbin/sshd -t -f /etc/ssh/sshd_config.new',
      :refreshonly => true,
      :require => file('/etc/ssh/sshd_config.new'),
      :notify => service('ssh')
    
  end
  
  private 
  
  # Sets up users and directories for chrooted, sftp-only access
  # By default, the chroot is /home/USERNAME and the user's home
  # will be inside that, at /home/USERNAME/home/USERNAME
  def sftponly(options)
    
    group 'sftponly', :ensure => :present
    
    exec "fake shell",
      :command => "echo /bin/false >> /etc/shells",
      :onlyif => "test -z `grep /bin/false /etc/shells`"
    
    (options[:users]||'sftponly').to_a.each do |user,hash|
      user = user.to_s
      
      chroot = options[:chroot_directory] || "/home/#{user}"
      homedir = chroot + ( hash[:home] || "/home/#{user}" )
      
      parent_directories homedir, :owner => 'root', :mode => '755'
      file homedir, 
        :ensure => :directory, 
        :owner => user, 
        :group => user, 
        :require => user(user)
      
      user user, 
        :ensure => :present,
        :home => "/home/#{user}/home/#{user}",
        :shell => "/bin/false",
        :groups => (['sftponly'] + hash[:groups].to_a).uniq,
        :require => [group('sftponly'),exec('fake shell')],
        :notify => exec("#{user} password")
      
      password = hash[:password] || rand_pass(6)
      exec "#{user} password",
        :command => "echo #{user}:#{password} | chpasswd",
        :refreshonly => true

    end
  end
  
  def parent_directories(path,options)
    options.merge!({:ensure => :directory})
    while path != "/"
      path = File.split(path)[0]
      file path, options
    end
  end
  
  def rand_pass(len)
    Array.new(len/2) { rand(256) }.pack('C*').unpack('H*').first
  end
  
end