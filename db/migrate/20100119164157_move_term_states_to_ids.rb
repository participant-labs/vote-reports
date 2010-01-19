class MoveTermStatesToIds < ActiveRecord::Migration
  def self.up
    add_column :politician_terms, :us_state_id, :integer
    constrain :politician_terms do |t|
      t.us_state_id :reference => {:us_states => :id}
    end
    PoliticianTerm.all(:select => 'DISTINCT state').map(&:state).each do |state|
      next if state.blank?
      us_state = UsState.first(:conditions => {:abbreviation => state})
      raise "State #{state} not found" if us_state.nil?
      PoliticianTerm.update_all({:us_state_id => us_state}, {:state => state})
    end
    remove_column :politician_terms, :state
  end

  def self.down
    raise "Irreversible"
  end
end
