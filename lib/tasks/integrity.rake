namespace :integrity do
  task :spec => [:setup, :spec]
  task :cucumber => [:setup, :cucumber]

  task :setup => :'db:test:prepare' do
    %w[database.yml secure_variables.rb].each do |path|
      FileUtils.cp("/srv/vote-reports/current/config/#{path}", RAILS_ROOT+"/config/#{path}")
    end
  end
end
