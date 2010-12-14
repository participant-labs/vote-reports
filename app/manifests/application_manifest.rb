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

  MONGO_VERSION = '1.6.3'

  # Add your application's custom requirements here
  def application_packages
    # If you've already told Moonshine about a package required by a gem with
    # :apt_gems in <tt>moonshine.yml</tt> you do not need to include it here.

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

    package 'optipng', :ensure => :installed

    nightly_update = "/usr/bin/rake -f #{configuration[:deploy_to]}/current/Rakefile update RAILS_ENV=#{ENV['RAILS_ENV']}"
    cron 'nightly update', :command => nightly_update, :user => configuration[:user], :minute => 0, :hour => 2
  end

  # The following line includes the 'application_packages' recipe defined above
  recipe :application_packages

  configure(
    :astrails_safe => {
      :local => {
        :path => '/srv/vote-reports/shared/data/backup/safe'
      },
      :keep => {
        :local => 3,
        :s3 => 100
      },
      :gpg => {
        :key => 'ben@votereports.org'
      },
      :s3 => {
        :key => '0YN0K8DPG0D52XG7WW82',
        :secret => 'azbToHx43247//SuoK//XMX7cMf1HGzYkgWphSPO',
        :bucket => 'vote-reports-production-backups',
      },
      :archives => [{
          :name => 'vote-reports',
          :files =>  '/srv/vote-reports',
          :exclude => [
            '/srv/vote-reports/shared/log',
            '/srv/vote-reports/shared/solr',
            '/srv/vote-reports/shared/cached-copy',
            '/srv/vote-reports/shared/data',
            '/srv/vote-reports/shared/pids'
          ]
        }
      ]
    },
    :denyhosts => {
      :admin_email => 'ben@votereports.org, root@localhost'
    },
    :iptables => { :rules => [
      '-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT',
      '-A INPUT -p icmp -j ACCEPT',
      '-A INPUT -p tcp -m tcp --dport 25 -j ACCEPT',
      '-A INPUT -p tcp -m tcp --dport 7111 -j ACCEPT',
      '-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT',
      '-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT',
      '-A INPUT -s 127.0.0.1 -j ACCEPT',
      '-A INPUT -p tcp -m tcp --dport 8000:10000 -j ACCEPT',
      '-A INPUT -p udp -m udp --dport 8000:10000 -j ACCEPT'
    ]},
    :ssh => {
      :port => 7111,
      :allow_users => [
        'root',
        'deploy'
      ]
    }
  )

  if deploy_stage == 'production'
    recipe :astrails_safe
    recipe :denyhosts
    recipe :scout
  end

  recipe :iptables
  recipe :ssh
  recipe :monit
  recipe :mongodb
end
