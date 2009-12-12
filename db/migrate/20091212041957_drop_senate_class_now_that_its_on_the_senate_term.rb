class DropSenateClassNowThatItsOnTheSenateTerm < ActiveRecord::Migration
  def self.up
    remove_column :politicians, :senate_class
  end

  def self.down
    add_column :politicians, :senate_class, :string
  end
end
