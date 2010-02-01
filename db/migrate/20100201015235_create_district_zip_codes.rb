class CreateDistrictZipCodes < ActiveRecord::Migration
  def self.up
    create_table :district_zip_codes do |t|
      t.integer :district_id, :null => false
      t.integer :zip_code, :null => false
      t.integer :plus_4

      t.timestamps
    end
    constrain :district_zip_codes do |t|
      t.district_id :reference => {:districts => :id}
      t[:district_id, :zip_code, :plus_4].all :unique => true
    end
  end

  def self.down
    drop_table :district_zip_codes
  end
end
