class Authentication < ActiveRecord::Base
  belongs_to :user

  class << self
    def find_or_create_from_auth_hash(auth_hash)
      auth = find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'].to_s)
      auth || begin
        user = User.find_or_create_from_auth_hash(auth_hash)
        user.authentications.create!(
          :provider   => auth_hash['provider'],
          :uid        => auth_hash['uid']
        )
      end
    end
  end
end
