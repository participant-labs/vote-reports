class FixPoliticiansWithMissingGovTrackIds < ActiveRecord::Migration
  def self.up
    Politician.all(:conditions => {:gov_track_id => nil}).each do |pol|
      politicians = Politician.find_all_by_first_name_and_last_name(pol.first_name, pol.last_name)
      if politicians.count == 1
        if pol.first_name == 'Robert'
          politicians += Politician.find_all_by_first_name_and_last_name('Bob', pol.last_name)
        elsif pol.first_name == 'Cynthia Ann'
          politicians += Politician.find_all_by_first_name_and_last_name('Cynthia', pol.last_name)
        elsif pol.first_name == 'Piyush'
          politicians += Politician.find_all_by_first_name_and_last_name('Bobby', pol.last_name)
        end
      end
      raise "Too many politicians: #{politicians.inspect}" if politicians.count > 2
      raise "No other politician for: #{politicians.inspect}" if politicians.count == 1
      proper_politician = (politicians - [pol]).first
      if proper_politician.vote_smart_id && proper_politician.vote_smart_id != pol.vote_smart_id
        msg = "Politician already had a vote_smart_id: #{proper_politician.inspect} vs. #{pol.inspect}"
        puts msg
        raise msg unless ['35481'].include?(pol.vote_smart_id)
      end
      puts "Redirecting #{pol.full_name} to #{proper_politician.inspect}"
      InterestGroupRating.update_all({:politician_id => proper_politician.id}, {:politician_id => pol.id})
      ReportScore.update_all({:politician_id => proper_politician.id}, {:politician_id => pol.id})
      pol.delete
      proper_politician.update_attribute(:vote_smart_id, pol.vote_smart_id)
    end
    change_column :politicians, :gov_track_id, :integer, :null => false
    constrain :politicians, :vote_smart_id, :blacklist => %w[26879]
  end

  def self.down
    change_column :politicians, :gov_track_id, :integer, :null => true
  end
end
