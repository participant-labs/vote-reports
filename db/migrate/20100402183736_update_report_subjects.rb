class UpdateReportSubjects < ActiveRecord::Migration
  def self.up
    ReportSubject.generate!
  end

  def self.down
  end
end
