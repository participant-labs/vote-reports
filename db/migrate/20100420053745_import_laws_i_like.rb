class ImportLawsILike < ActiveRecord::Migration
  def self.up
    Rake::Task['laws_i_like:import'].invoke
  end

  def self.down
  end
end
