class DropNameAndDescriptionFromCausesAndInterestGroups < ActiveRecord::Migration
  def self.up
    Cause.paginated_each do |cause|
      (cause.report || cause.create_report(:name => cause.name, :description => cause.description)
      ).update_attributes!(:name => cause.name, :description => cause.description)
    end
    InterestGroup.paginated_each do |interest_group|
      (interest_group.report || interest_group.create_report(:name => interest_group.name, :description => interest_group.description)
      ).update_attributes!(:name => interest_group.name, :description => interest_group.description)
    end
  end

  def self.down
  end
end
