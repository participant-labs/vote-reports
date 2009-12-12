class FixTypoEventfulIdNotEventId < ActiveRecord::Migration
  def self.up
    transaction do
      rename_column :politicians, :event_id, :eventful_id
      Politician.all.each do |p|
        p.load_sunlight_labs_data
        p.save!
      end
    end
  end

  def self.down
    rename_column :politicians, :eventful_id, :event_id
  end
end
