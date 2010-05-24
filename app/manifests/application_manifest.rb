require "#{File.dirname(__FILE__)}/../../vendor/plugins/moonshine/lib/moonshine.rb"
class ApplicationManifest < Moonshine::Manifest::Rails
  # The majority of your configuration should be in <tt>config/moonshine.yml</tt>
  # If necessary, you may provide extra configuration directly in this class
  # using the configure method. The hash passed to the configure method is deep
  # merged with what is in <tt>config/moonshine.yml</tt>. This could be used,
  # for example, to store passwords and/or private keys outside of your SCM, or
  # to query a web service for configuration data.
  #
  # In the example below, the value configuration[:custom][:random] can be used in
  # your moonshine settings or templates.
  #
  # require 'net/http'
  # require 'json'
  # random = JSON::load(Net::HTTP.get(URI.parse('http://twitter.com/statuses/public_timeline.json'))).last['id']
  # configure({
  #   :custom => { :random => random  }
  # })

  # The default_stack recipe install Rails, Apache, Passenger, the database from
  # database.yml, Postfix, Cron, logrotate and NTP. See lib/moonshine/manifest/rails.rb
  # for details. To customize, remove this recipe and specify the components you want.
  recipe :default_stack

  # Add your application's custom requirements here
  def application_packages
    # If you've already told Moonshine about a package required by a gem with
    # :apt_gems in <tt>moonshine.yml</tt> you do not need to include it here.
    # package 'some_native_package', :ensure => :installed

    # some_rake_task = "/usr/bin/rake -f #{configuration[:deploy_to]}/current/Rakefile custom:task RAILS_ENV=#{ENV['RAILS_ENV']}"
    # cron 'custom:task', :command => some_rake_task, :user => configuration[:user], :minute => 0, :hour => 0

    # %w( root rails ).each do |user|
    #   mailalias user, :recipient => 'you@domain.com'
    # end

    # farm_config = <<-CONFIG
    #   MOOCOWS = 3
    #   HORSIES = 10
    # CONFIG
    # file '/etc/farm.conf', :ensure => :present, :content => farm_config

    # Logs for Rails, MySQL, and Apache are rotated by default
    # logrotate '/var/log/some_service.log', :options => %w(weekly missingok compress), :postrotate => '/etc/init.d/some_service restart'

    # Only run the following on the 'testing' stage using capistrano-ext's multistage functionality.
    # on_stage 'testing' do
    #   file '/etc/motd', :ensure => :file, :content => "Welcome to the TEST server!"
    # end

    delayed_job_monit = <<-DJ
      check process delayed_job with pidfile /srv/vote-reports/shared/pids/delayed_job.pid
      start program = "/srv/vote-reports/current/script/delayed_job -e production start"
      stop program = "/srv/vote-reports/current/script/delayed_job -e production stop"
    DJ

    file '/etc/monit.d/delayed_job',
      :mode => '600',
      :owner => configuration[:user],
      :group => configuration[:group] || configuration[:user],
      :require => file('/etc/monit.d')
      :content => 

    configure(:iptables => { :rules => [
      '-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT',
      '-A INPUT -p icmp -j ACCEPT',
      '-A INPUT -p tcp -m tcp --dport 25 -j ACCEPT',
      '-A INPUT -p tcp -m tcp --dport 7111 -j ACCEPT',
      '-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT',
      '-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT',
      '-A INPUT -s 127.0.0.1 -j ACCEPT',
      '-A INPUT -p tcp -m tcp --dport 8000:10000 -j ACCEPT',
      '-A INPUT -p udp -m udp --dport 8000:10000 -j ACCEPT'
    ]})

    configure(:denyhosts => {
      :admin_email => 'ben@votereports.org, root@localhost'
    })

    configure(:mongodb => {:version => '1.4.2'})

    configure(:monit => {:gui => true})
  end

  # The following line includes the 'application_packages' recipe defined above
  recipe :application_packages

  if deploy_stage == 'production'
    recipe :denyhosts
    recipe :iptables
    recipe :scout
    recipe :ssh
  end
  recipe :monit
  recipe :mongodb

  def integrity_vhost
    file '/srv/integrity',
      :ensure => :directory,
      :owner => configuration[:user]

    static_vhost = <<-VHOST
    <VirtualHost *:80>
        ServerName ci.votereports.org
        DocumentRoot /srv/integrity/public
        <Directory /srv/integrity/public>
            Allow from all
            Options -MultiViews
        </Directory>
    </VirtualHost>
    VHOST

    file "/etc/apache2/sites-available/integrity",
      :alias => 'integrity',
      :ensure => :present,
      :content => static_vhost,
      :notify => service("apache2"),
      :require => file('/srv/integrity')

    a2ensite "integrity"
  end
  if deploy_stage == 'staging'
    recipe :integrity_vhost
  end
end
