class AddAuthlogicRpxMigration < ActiveRecord::Migration
  def self.up
    create_table :rpx_identifiers do |t|
      t.string  :identifier, :null => false
      t.string  :provider_name
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :rpx_identifiers, :identifier, :unique => true, :null => false
    add_index :rpx_identifiers, :user_id, :unique => false, :null => false

    constrain :rpx_identifiers do |t|
      t.user_id :reference => {:users => :id, :on_delete => :cascade}
    end

    # == Customisation may be required here ==
    # You may need to remove database constraints on other fields if they will be unused in the RPX case
    # (e.g. crypted_password and password_salt to make password authentication optional). 
    # If you are using auto-registration, you must also remove any database constraints for fields that will be automatically mapped
    # e.g.:
    change_column :users, :crypted_password, :string, :default => nil, :null => true
    change_column :users, :salt, :string, :default => nil, :null => true
  end

  def self.down
    drop_table :rpx_identifiers
  end
end
