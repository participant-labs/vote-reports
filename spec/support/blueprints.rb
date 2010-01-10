Fixjour :verify => true do
  def meeting
    Forgery(:basic).number(:at_least => 103, :at_most => 111)
  end

  def bill_type
    Forgery(:basic).text(:at_least => 2, :at_most => 2, :allow_numeric => false, :allow_upper => false)
  end

  def bill_number
    Forgery(:basic).number(:at_most => 9999)
  end

  def opencongress_id
    "#{meeting}-#{bill_type}#{bill_number}"
  end

  def gov_track_id
    "#{bill_type}#{meeting}-#{bill_number}"
  end

  define_builder(Party) do |klass, overrides|
    klass.new(
      :name => Forgery(:basic).text
    )
  end

  define_builder(Committee) do |klass, overrides|
    klass.new(
      :display_name => Forgery(:basic).text,
      :code => Forgery(:basic).text
    )
  end

  define_builder(CommitteeMeeting) do |klass, overrides|
    klass.new(
      :committee => new_committee,
      :congress => new_congress,
      :name => Forgery(:basic).text
    )
  end

  define_builder(User) do |klass, overrides|
    klass.new(
      :email => Forgery(:internet).email_address,
      :username => Forgery(:internet).user_name,
      :password => 'password',
      :password_confirmation => 'password'
    )
  end

  define_builder(Report) do |klass, overrides|
    klass.new(:name => Forgery(:basic).text, :user => new_user)
  end

  define_builder(Amendment) do |klass, overrides|
    klass.new(
      :purpose => Forgery(:basic).text,
      :description => Forgery(:basic).text,
      :sponsor => send("create_#{%w[politician committee_meeting].rand}"),
      :bill => new_bill,
      :number => rand(1000),
      :offered_on => "12/13/2009",
      :chamber => ['h', 's'].rand,
      :congress => new_congress)
  end

  define_builder(Congress) do |klass, overrides|
    meeting = rand(200)
    meeting = rand(200) while Congress.find_by_meeting(meeting)
    klass.new(:meeting => meeting)
  end

  define_builder(BillTitle) do |klass, overrides|
    klass.new(
      :title => Forgery(:basic).text,
      :title_type => 'official',
      :as => Forgery(:basic).text,
      :bill => new_bill
    )
  end

  define_builder(Bill) do |klass, overrides|
    klass.new(
      :opencongress_id => opencongress_id,
      :gov_track_id => gov_track_id,
      :introduced_on => '12/13/2009',
      :bill_type => 'hr',
      :bill_number => bill_number,
      :sponsor => new_politician,
      :congress => Congress.find_or_create_by_meeting(rand(200))
    )
  end

  define_builder(BillCriterion) do |klass, overrides|
    klass.new(:report => new_report, :bill => new_bill, :support => true)
  end

  define_builder(Politician) do |klass, overrides|
    klass.new(
      :gov_track_id => rand(1000000),
      :first_name => Forgery(:name).first_name,
      :last_name => Forgery(:name).last_name
    )
  end

  define_builder(Vote) do |klass, overrides|
    klass.new(
      :politician => new_politician,
      :roll => new_roll,
      :vote => %w[+ - P 0].rand
    )
  end

  define_builder(Roll) do |klass, overrides|
    klass.new(
      :congress => Congress.find_or_create_by_meeting(rand(200)),
      :subject => new_bill,
      :gov_track_id => Forgery(:basic).text,
      :where => Forgery(:basic).text,
      :result => Forgery(:basic).text,
      :required => Forgery(:basic).text,
      :question => Forgery(:basic).text,
      :roll_type => Forgery(:basic).text,
      :aye => rand(500),
      :nay => rand(500),
      :not_voting => rand(500),
      :present => rand(500)
    )
  end

  define_builder(PresidentialTerm) do |klass, overrides|
    klass.new(
      :politician => new_politician,
      :party => new_party
    )
  end

  define_builder(RepresentativeTerm) do |klass, overrides|
    klass.new(
      :politician => new_politician,
      :party => new_party,
      :state => UsState::US_STATES.rand.last,
      :district => rand(100)
    )
  end

  define_builder(SenateTerm) do |klass, overrides|
    klass.new(
      :politician => new_politician,
      :party => new_party,
      :senate_class => [1, 2, 3].rand,
      :state => UsState::US_STATES.rand.last
    )
  end
end
