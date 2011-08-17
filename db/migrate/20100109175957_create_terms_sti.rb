class CreateTermsSti < ActiveRecord::Migration
  def self.up
    transaction do
      initial_rep_count = RepresentativeTerm.count
      add_column :representative_terms, :created_at, :datetime
      add_column :representative_terms, :updated_at, :datetime
      RepresentativeTerm.update_all(:created_at => DateTime.now)

      add_column :representative_terms, :senate_class, :integer

      add_column :representative_terms, :type, :string
      constrain :representative_terms do |t|
        t[:type].all :whitelist => %w[RepresentativeTerm SenateTerm PresidentialTerm]
      end
      RepresentativeTerm.update_all(:type => 'RepresentativeTerm')
      change_column :representative_terms, :type, :string, :null => false

      change_table :representative_terms do |t|
        t.change :district, :integer, :null => true
        t.change :state, :string, :null => true
      end
      deconstrain :representative_terms do |t|
        t.state :not_blank
      end

      RepresentativeTerm.reset_column_information
      cols = ['senate_class', "party_id", "created_at", "politician_id", "district", "updated_at", "ended_on", "url", "type", "started_on", "state"]
      RepresentativeTerm.import_without_validations_or_callbacks cols, (SenateTerm.all.map do |term|
        attrs = term.attributes.merge('type' => 'SenateTerm')
        cols.map {|col| attrs[col] }
      end)
      RepresentativeTerm.import_without_validations_or_callbacks cols, (PresidentialTerm.all.map do |term|
        attrs = term.attributes.merge("type" => 'PresidentialTerm')
        cols.map {|col| attrs[col] }
      end)
      raise "Didn't transfer enough" if RepresentativeTerm.count != initial_rep_count + SenateTerm.count + PresidentialTerm.count
      rename_table :representative_terms, :terms
    end
  end

  def self.down
    rename_table :terms, :representative_terms
    RepresentativeTerm.delete_all(:type => 'SenateTerm')
    RepresentativeTerm.delete_all(:type => 'PresidentialTerm')
    constrain :representative_terms do |t|
      t.state :not_blank => true
    end
    remove_column :representative_terms, :created_at
    remove_column :representative_terms, :updated_at
    remove_column :representative_terms, :type
    remove_column :representative_terms, :senate_class
  end
end
