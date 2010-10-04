class CoalesceOfficeTypes < ActiveRecord::Migration
  def self.up
    add_column :elections, :office_type_id, :integer
    add_foreign_key :elections, :office_types

    say_with_time "Updating election office types to be foreign-key based" do
      Election.paginated_each do |election|
        election.update_attribute(:office_type_id, OfficeType.find_by_vote_smart_id(election.office_type).id)
        print '.'
      end
    end

    change_column_null :elections, :office_type_id, false
    remove_column :elections, :office_type
  end

  def self.down
    raise 'nope'
  end
end
