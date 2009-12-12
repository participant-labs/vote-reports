class FixTypoEventfulIdNotEventId < ActiveRecord::Migration
  def self.up
    transaction do
      rename_column :politicians, :event_id, :eventful_id
      Politician.all.each do |p|
        begin
          p.load_sunlight_labs_data
          p.save!
        rescue
          raise [p, p.errors.full_messages].inspect
        end
      end
    end
  end

  def self.down
    rename_column :politicians, :eventful_id, :event_id
  end
end
