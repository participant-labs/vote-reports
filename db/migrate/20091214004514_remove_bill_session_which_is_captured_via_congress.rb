class RemoveBillSessionWhichIsCapturedViaCongress < ActiveRecord::Migration
  def self.up
    remove_column :bills, :session
  end

  def self.down
    add_column :bills, :session, :string
  end
end
