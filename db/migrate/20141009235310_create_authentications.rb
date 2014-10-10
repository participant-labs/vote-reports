class CreateAuthentications < ActiveRecord::Migration
  def up
    create_table :authentications do |t|
      t.text :provider, null: false
      t.text :uid, null: false
      t.json :info, null: false
      t.text :token
      t.text :secret
      t.json :raw_info
    end
    add_index :authentications, [:provider, :uid], unique: true
  end

  def down
    drop_table :authentications
  end
end
