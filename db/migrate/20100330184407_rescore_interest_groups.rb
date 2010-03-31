class RescoreInterestGroups < ActiveRecord::Migration
  def self.up
    InterestGroup.paginated_each do |ig|
      ig.rescore!
    end
  end

  def self.down
  end
end
