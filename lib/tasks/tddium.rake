namespace :tddium do
  desc "load database extensions"
  task db_hook: :"db:create" do
    # Copyright (c) 2011, 2012 Solano Labs All Rights Reserved
    # https://gist.github.com/3006942
    Kernel.system("psql #{ENV['TDDIUM_DB_NAME']} -c 'CREATE EXTENSION postgis;'")

    Rake::Task["tddium:default_db_hook"].invoke
  end
end
