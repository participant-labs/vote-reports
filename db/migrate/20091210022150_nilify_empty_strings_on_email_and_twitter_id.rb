class NilifyEmptyStringsOnEmailAndTwitterId < ActiveRecord::Migration
  def self.up
    Politician.update_all({:email => nil}, {:email => ''})
    Politician.update_all({:twitter_id => nil}, {:twitter_id => ''})
  end

  def self.down
  end
end
