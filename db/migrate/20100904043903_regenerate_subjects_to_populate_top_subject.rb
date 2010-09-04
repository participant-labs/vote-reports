class RegenerateSubjectsToPopulateTopSubject < ActiveRecord::Migration
  def self.up
    say_with_time "Regenerating ReportSubjects" do
      ReportSubject.generate!
    end
  end

  def self.down
  end
end
