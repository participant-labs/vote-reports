class ImportLawsILike < ActiveRecord::Migration
  def self.up
    Report.reset_column_information
    Rake::Task['laws_i_like:unpack'].invoke
  end

  def self.down
  end
end
