class UpdateTitles < ActiveRecord::Migration
  def self.up
    Politician.update_titles!
  end

  def self.down
  end
end
