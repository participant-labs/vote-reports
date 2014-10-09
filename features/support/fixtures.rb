Before do
  ActiveRecord::Fixtures.reset_cache
  fixtures_folder = File.join(Rails.root, 'spec', 'fixtures')
  fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
  ActiveRecord::Fixtures.create_fixtures(fixtures_folder, fixtures)
end
