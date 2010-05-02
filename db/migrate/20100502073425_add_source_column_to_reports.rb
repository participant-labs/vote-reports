class AddSourceColumnToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :source, :string
    Report.update_all({:source => 'laws_i_like'}, {:name => 'Laws I Like'})
  end

  def self.down
    remove_column :reports, :source
  end
end
