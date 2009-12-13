class UnpackSunlightDataFromCsv < ActiveRecord::Migration
  def self.up
    Rake::Task['sunlight:politicians:unpack'].invoke
  end

  def self.down
  end
end
