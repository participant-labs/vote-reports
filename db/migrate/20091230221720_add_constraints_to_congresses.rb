class AddConstraintsToCongresses < ActiveRecord::Migration
  def self.up
    constrain :congresses do |t|
      t.meeting :unique => true
    end
  end

  def self.down
    deconstrain :congresses do |t|
      t.meeting :unique
    end
  end
end
