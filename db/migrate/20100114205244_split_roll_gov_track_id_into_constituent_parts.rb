class SplitRollGovTrackIdIntoConstituentParts < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :rolls, :year, :integer
      add_column :rolls, :number, :integer

      Roll.all(:select => "gov_track_id, id").each do |roll|
        year, number = roll.gov_track_id.match(/.(\d+)-(\d+)/).captures
        roll.update_attributes!(:year => year, :number => number)
      end

      change_table :rolls do |t|
        t.change :year, :integer, :null => false
        t.change :number, :integer, :null => false
        t.change :subject_id, :integer, :null => false
        t.change :subject_type, :string, :null => false
        t.change :roll_type, :string, :null => false
        t.change :congress_id, :integer, :null => false
      end

      constrain :rolls do |t|
        t.where :whitelist => %w[senate house]
        t[:number, :year, :where].all :unique => true
      end
    end
  end

  def self.down
  end
end
