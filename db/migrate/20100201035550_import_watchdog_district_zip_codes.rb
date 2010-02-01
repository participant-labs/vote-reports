class ImportWatchdogDistrictZipCodes < ActiveRecord::Migration
  def self.up
    transaction do
      Rake::Task['watchdog:zip_codes:download'].invoke
      Rake::Task['watchdog:zip_codes:unpack'].invoke
    end
  end

  def self.down
  end
end
