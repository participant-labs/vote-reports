class StripDescriptionTagsFromReports < ActiveRecord::Migration
  def self.up
    transaction do
      Report.update_all(:description => '')
    end
  end

  def self.down
  end
end
