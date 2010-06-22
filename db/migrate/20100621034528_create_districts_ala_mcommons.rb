class CreateDistrictsAlaMcommons < ActiveRecord::Migration
  def self.up
    config = Rails::Configuration.new
    db     = config.database_configuration[RAILS_ENV]["database"]
    user   = config.database_configuration[RAILS_ENV]["username"]
    host   = config.database_configuration[RAILS_ENV]["host"]
    password   = config.database_configuration[RAILS_ENV]["password"]

    `PGPASSWORD="#{password}" psql -d #{db} -U #{user} -c 'CREATE LANGUAGE plpgsql' -h #{host}`
    if Rails.env.development?
      `psql -d #{db} -f /opt/local/share/postgresql84/contrib/postgis-1.5/postgis.sql -U #{user} -h #{host}`
      `psql -d #{db} -f /opt/local/share/postgresql84/contrib/postgis-1.5/spatial_ref_sys.sql -U #{user} -h #{host}`
    else
      `PGPASSWORD="#{password}" psql -d #{db} -f /usr/share/postgresql/8.4/contrib/postgis.sql -U #{user} -h #{host}`
      `PGPASSWORD="#{password}" psql -d #{db} -f /usr/share/postgresql/8.4/contrib/spatial_ref_sys.sql -U #{user} -h #{host}`
    end
    `PGPASSWORD="#{password}" psql -d #{db} -f #{Rails.root.join('db/congress.sql')} -U #{user} -h #{host}`

    add_index "districts", "the_geom", :spatial=>true

    add_column :districts, :state_name, :string
    add_column :districts, :level, :string

    execute "UPDATE districts SET level = 'federal'"
    execute "UPDATE districts SET name = '1' where name = 'One'"

    UsState::FIPS_CODES.each do |fips_code, name|
      District.update_all({:state_name => name}, {:state => fips_code})
    end
  end

  def self.down
    drop_table :districts
  end
end
