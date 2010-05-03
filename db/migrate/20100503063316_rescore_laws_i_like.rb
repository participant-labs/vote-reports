class RescoreLawsILike < ActiveRecord::Migration
  def self.up
    # rescore all as ReportSubjects at least are out of sync
    Report.all.map(&:rescore!)
  end

  def self.down
  end
end
