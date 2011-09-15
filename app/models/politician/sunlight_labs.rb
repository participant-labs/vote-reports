class Politician < ActiveRecord::Base
  module SunlightLabs

    def self.included(base)
      {
        firstname: :first_name,
        middlename: :middle_name,
        lastname: :last_name,
        :govtrack_id => :gov_track_id,
        :votesmart_id => :vote_smart_id,
        birthdate: :birthday
      }.each_pair do |sunlight_name, votereports_name|
        base.alias_attribute sunlight_name, votereports_name
      end
    end

  end
end
