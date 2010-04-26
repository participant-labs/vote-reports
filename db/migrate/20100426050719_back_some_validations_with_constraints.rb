class BackSomeValidationsWithConstraints < ActiveRecord::Migration
  def self.up
    Politician::IDENTITY_STRING_FIELDS.each do |field|
      constrain :politicians, field, :not_blank => true
    end
    Politician::IDENTITY_FIELDS.each do |field|
      add_index :politicians, field, :unique => true
    end
  end

  def self.down
    raise 'nope'
  end
end
