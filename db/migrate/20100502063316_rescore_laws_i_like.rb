class RescoreLawsILike < ActiveRecord::Migration
  def self.up
    Report.all(:conditions => {:name => 'Laws I Like'}).map(&:rescore!)
  end

  def self.down
  end
end
