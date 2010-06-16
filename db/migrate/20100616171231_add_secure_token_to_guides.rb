class AddSecureTokenToGuides < ActiveRecord::Migration
  def self.up
    GuideReport.delete_all
    Guide.delete_all
    add_column :guides, :secure_token, :string, :null => false
    add_index :guides, :secure_token, :unique => true
  end

  def self.down
    remove_column :guides, :secure_token
  end
end
