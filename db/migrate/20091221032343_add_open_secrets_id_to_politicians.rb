class AddOpenSecretsIdToPoliticians < ActiveRecord::Migration
  def self.up
    add_column :politicians, :open_secrets_id, :string
  end

  def self.down
    remove_column :politicians, :open_secrets_id
  end
end
