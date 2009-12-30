class ConstrainReports < ActiveRecord::Migration
  def self.up
    constrain :reports do |t|
      t.user_id :not_null => true, :reference => {:users => :id, :on_delete => :cascade}
      t.name :not_null => true, :not_blank => true
    end
  end

  def self.down
    deconstrain :reports do |t|
      t.user_id :not_null, :reference
      t.name :not_null, :not_blank
    end
  end
end
