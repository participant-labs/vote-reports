class PaulKirkDoesntNeedHisPhone < ActiveRecord::Migration
  def self.up
    # replaced by Scott Brown
    Politician.find_by_vote_smart_id('116298').update_attribute(:phone, nil)
  end

  def self.down
  end
end
