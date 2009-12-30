class ConstrainPoliticians < ActiveRecord::Migration
  def self.up
    constrain :politicians do |t|
      Politician::IDENTITY_STRING_FIELDS.each do |field|
        t.send(field, :not_blank => true, :unique => true)
      end
      Politician::IDENTITY_INTEGER_FIELDS.each do |field|
        t.send(field, :unique => true)
      end
    end    
  end

  def self.down
    deconstrain :politicians do |t|
      Politician::IDENTITY_STRING_FIELDS.each do |field|
        t.send(field, :not_blank, :unique)
      end
      Politician::IDENTITY_INTEGER_FIELDS.each do |field|
        t.send(field, :unique)
      end
    end    
  end
end
