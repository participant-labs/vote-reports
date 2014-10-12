FactoryGirl.define do
  factory :report do
    name { Forgery(:basic).text }
    user { User.all.sample || create(:user) }

    trait :personal do
      state 'personal'
    end

    trait :unlisted do
      after :create do |report|
        report.share
      end
    end

    trait :unscored do
      after :create do |report|
        create(:bill_criterion, report: report)
        Delayed::Worker.new.work_off
      end
    end

    trait :scored do
      unscored
      after :create do |report|
        create(:politician) if Politician.count == 0
        roll = create(:roll, subject: report.bill_criteria.first.bill, roll_type: "On Passage")
        Politician.find_each do |p|
          create(:vote, roll: roll, politician: p, vote: Vote::POSSIBLE_VALUES.sample)
        end
        report.rescore!
        Delayed::Worker.new.work_off
      end
    end

    trait :published do
      scored
      after :create do |report|
        report.reload
        report.publish
        raise report.errors.full_messages.inspect unless report.published?
      end
    end
  end

  factory :report_score, aliases: [:score] do
    score { rand(100) }
    politician
    report
  end

  factory :report_score_evidence do
    score
    association :evidence, factory: :roll
    association :criterion, factory: :bill_criterion
  end

  factory :report_subject do
    report
    subject
    count { rand(10) }
  end
end
