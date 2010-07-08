class CreateIssueCauses < ActiveRecord::Migration
  def self.up
    create_table :issue_causes do |t|
      t.integer :issue_id, :null => false
      t.integer :cause_id, :null => false

      t.timestamps
    end
    constrain :issue_causes do |t|
      t.issue_id :reference => {:issues => :id}
      t.cause_id :reference => {:causes => :id}
    end
    add_index :issue_causes, :issue_id
    add_index :issue_causes, :cause_id
    add_index :issue_causes, [:issue_id, :cause_id], :uniq => true
  end

  def self.down
    drop_table :issue_causes
  end
end
