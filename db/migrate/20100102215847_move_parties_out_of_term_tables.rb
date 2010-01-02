class MovePartiesOutOfTermTables < ActiveRecord::Migration
  def self.party_id(name)
    @parties ||= Party.all.index_by(&:name)
    @parties.fetch(name) do
      @parties[name] = Party.create(:name => name)
    end.id
  end

  def self.up
    transaction do
      blacklist = ['no party']
      add_index :parties, :name, :unique => true
      constrain :parties do |t|
        t.name :blacklist => blacklist
      end
      [:senate_terms, :representative_terms, :presidential_terms].each do |table|
        add_column table, :party_id, :integer
        table.to_s.singularize.camelcase.constantize.all(:select => 'id, party', :conditions => "party IS NOT NULL").each do |term|
          next if blacklist.include?(term[:party])
          term.update_attribute(:party_id, party_id(term[:party]))
        end
        remove_column table, :party
        constrain table do |t|
          t.party_id :reference => {:parties => :id}
        end
      end
    end
  end

  def self.down
    raise "Irreversible (just a pain in the ass to do so, really)"
  end
end
