class StricterInterestGroupDetails < ActiveRecord::Migration
  def self.up
    change_column :interest_group_reports, :interest_group_id, :integer, :null => false
    change_column :interest_group_reports, :vote_smart_id, :integer, :null => false
    change_column :interest_group_reports, :timespan, :string, :null => false

    [:description, :email, :url, :contact_name, :phone1, :phone2, :fax, :address, :city, :state, :zip].each do |field|
      InterestGroup.update_all({field => nil}, {field => ''})
    end

    constrain :interest_groups do |t|
      t.name :not_blank => true
      t.description :not_blank => true
      t.email :not_blank => true
      t.url :not_blank => true
      t.contact_name :not_blank => true
      t.phone1 :not_blank => true
      t.phone2 :not_blank => true
      t.fax :not_blank => true
      t.address :not_blank => true
      t.city :not_blank => true
      t.state :not_blank => true
      t.zip :not_blank => true
    end
  end

  def self.down
    raise 'Nope'
  end
end
