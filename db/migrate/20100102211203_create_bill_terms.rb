class CreateBillTerms < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :terms do |t|
        t.string :name, :null => false
      end
      constrain :terms do |t|
        t.name :not_blank => true
      end
    end
  end

  def self.down
    drop_table :terms
  end
end
