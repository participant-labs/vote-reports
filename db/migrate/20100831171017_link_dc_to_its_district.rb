class LinkDcToItsDistrict < ActiveRecord::Migration
  def self.up
    District.geocode('washington, dc').select(&:federal?).map {|d| d.update_attributes(:name => 'At large') }
  end

  def self.down
    District.geocode('washington, dc').select(&:federal?).map {|d| d.update_attributes(:name => '98') }
  end
end
