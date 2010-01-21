class ConstrainAmendmentNumberToBillId < ActiveRecord::Migration
  def self.up
    constrain :amendments do |t|
      t[:number, :bill_id, :chamber].all :unique => true
    end
  end

  def self.down
    deconstrain :amendments do |t|
      t[:number, :bill_id, :chamber].all :unique
    end
  end
end
