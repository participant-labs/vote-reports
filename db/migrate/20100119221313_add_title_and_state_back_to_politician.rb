class AddTitleAndStateBackToPolitician < ActiveRecord::Migration
  def self.up
    add_column :politicians, :title, :string
    add_column :politicians, :us_state_id, :integer
    Rake::Task['calculations:politicians:latest_term_results'].invoke
  end

  def self.down
    remove_column :politicians, :title, :us_state_id
  end
end
