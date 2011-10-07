class AddFacebookIdToPoliticians < ActiveRecord::Migration
  def change
    add_column :politicians, :facebook_id, :string
    add_index :politicians, :facebook_id, unique: true
  end
end
