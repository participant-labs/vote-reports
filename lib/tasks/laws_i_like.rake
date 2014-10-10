namespace :laws_i_like do
  task :count_users do
    require 'excelsior'
    users = {}
    Excelsior::Reader.rows(File.open(
      Rails.root.join('config/data/laws_i_like/lawslike_18042010.csv'), 'rb')) do |row|
      users[row.first] = true
    end
    puts "#{users.keys.size} users"
  end

  task unpack: :environment do
    require 'facebooker'

    def facebook_user(fb_id)
      @facebook_users ||= begin
        Facebooker::Session.current = Facebooker::Session.create
        {}
      end
      @facebook_users.fetch(fb_id) do
        @facebook_users[fb_id] = Facebooker::User.new(fb_id).tap do |user|
          retries = 0
          begin
            user.populate()
          rescue
            retries += 1
            if retries < 5
              puts "retrying"
              sleep (retries ** 3)
              retry
            end
            raise
          end
        end
      end
    end

    def rpx_identifier(fb_id)
      identifier = "http://www.facebook.com/profile.php?id=#{fb_id}"
      RPXIdentifier.find_by_identifier_and_provider_name(
        identifier, "Facebook") \
      || RPXIdentifier.new(
        identifier: identifier,
        provider_name: "Facebook")
    end

    require 'excelsior'
    $stdout.sync = true
    count = 0

    class Report < ActiveRecord::Base
      has_many :bill_criteria, dependent: :destroy
      def rescore!
        # overwrite for now so as not to slow things down
      end
    end

    rescue_and_reraise do
      ActiveRecord::Base.transaction do
        Excelsior::Reader.rows(File.open(
          Rails.root.join('data/laws_i_like/lawslike_18042010.csv'), 'rb')) do |row|
          # 618219,0,S. 431,s,431,Economic Recovery Adjustment Act of 2009,111,http://www.govtrack.us/congress/bill.xpd?bill=s111-431,06/12/2009
          fb_id, support, bill_ref, bill_house, bill_number, bill_title, bill_meeting, bill_gov_track_url, liked_on = row

          next if fb_id == "NO_USER"

          fb_user = facebook_user(fb_id)
          identifier = rpx_identifier(fb_id)
          name = fb_user.username
          name = fb_user.name if name.blank?
          name = fb_user.id.to_s if name.blank?

          user =
            if identifier.user_id
              User.find(identifier.user_id)
            else
              #fake the user - due to validation problems :-(
              identifier.user_id = User.first.id
              identifier.save!
              User.create!(
                username: name,
                email: "#{name.tr(' ', '_')}+facebook@votereports.org",
                rpx_identifiers: [identifier]
              )
            end
          identifier.update_attribute(:user_id, user.id)
          report = user.reports.create_with(
            source: 'laws_i_like',
            state: 'private',
            description: 'These scores are based on the bills I voted on with the [Laws I Like](http://apps.facebook.com/lawsilike/) Facebook App'
          ).find_or_create_by(
            name: 'Laws I Like',
          )

          bill_type = begin
            if bill_ref.starts_with?('H.R. ')
              'h'
            elsif bill_ref.starts_with?('H.Res. ')
              'hr'
            elsif bill_ref.starts_with?('H.J.Res. ')
              'hj'
            elsif bill_ref.starts_with?('H.Con.Res. ')
              'hc'
            elsif bill_ref.starts_with?('S. ')
              's'
            elsif bill_ref.starts_with?("S.Res. ")
              'sr'
            elsif bill_ref.starts_with?("S.J.Res. ")
              'sj'
            elsif bill_ref.starts_with?("S.Con.Res. ")
              'sc'
            else
              raise "Unrecognized type for #{bill_ref}"
            end
          end

          bill_id = "#{bill_meeting}-#{bill_type}#{bill_number}"
          bill = Bill.find_by_opencongress_id(bill_id) || raise("Bill not found: #{bill_id}")
          report.bill_criteria.find_by_bill_id(bill.id) || report.bill_criteria.create!(
            bill_id: bill.id,
            support: support == '1',
            created_at: liked_on.to_date
          )
          count += 1
          $stdout.print '.'
        end
      end
    end
  end
end
