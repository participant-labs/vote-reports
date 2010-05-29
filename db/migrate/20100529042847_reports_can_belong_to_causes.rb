class ReportsCanBelongToCauses < ActiveRecord::Migration
  def self.up
    add_column :reports, :cause_id, :integer

    constrain :reports do |t|
      t.cause_id :reference => {:causes => :id}
    end
  end

  def self.down
    remove_column :reports, :cause_id
  end
end
