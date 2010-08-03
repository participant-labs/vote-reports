class AddCachedSlugToAmendments < ActiveRecord::Migration
  def self.up
    add_column :amendments, :short_name, :string
    add_index :amendments, :short_name
    add_index :amendments, [:short_name, :bill_id], :unique => true
    add_index :causes, :cached_slug

    Amendment.paginated_each do |amendment|
      amendment.update_attribute(:short_name, "#{amendment.chamber}-#{amendment.number}")
    end

    change_column_null :amendments, :short_name, false
  end

  def self.down
    remove_column :amendments, :short_name
    remove_index :causes, :cached_slug
  end
end
