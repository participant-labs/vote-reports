class AddInOfficeToPoliticians < ActiveRecord::Migration
  def self.up
    add_column :politicians, :current_office_id, :integer
    add_column :politicians, :current_office_type, :string
    Politician.update_current_office_status!
  end

  def self.down
    remove_column :politicians, :current_office_id, :current_office_type
  end
end
