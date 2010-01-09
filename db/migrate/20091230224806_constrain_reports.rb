class ConstrainReports < ActiveRecord::Migration
  def self.up
    change_table :reports do |t|
      t.change :user_id, :integer, :null => false
      t.change :name, :string, :null => false
    end

    constrain :reports do |t|
      t.user_id :reference => {:users => :id, :on_delete => :cascade}
      t.name :not_blank => true
    end
  end

  def self.down
    change_table :reports do |t|
      t.change :user_id, :integer, :null => true
      t.change :name, :string, :null => true
    end

    deconstrain :reports do |t|
      t.user_id :not_null, :reference
      t.name :not_null, :not_blank
    end
  end
end
