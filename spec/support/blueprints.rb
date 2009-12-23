Fixjour :verify => true do
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
    klass.new(:title => Forgery(:basic).text, :bill => new_bill, :gov_track_id => rand(1000000))
  end

  define_builder(Congress) do |klass, overrides|
    klass.new(:meeting => 111)
  end

  define_builder(Bill) do |klass, overrides|
    klass.new(
      :title => Forgery(:basic).text,
      :opencongress_id => Forgery(:basic).text,
      :gov_track_id => rand(1000000),
      :bill_type => 'hr',
      :sponsor => new_politician,
      :congress => Congress.find_or_create_by_meeting(111)
    )
  end

  define_builder(BillCriterion) do |klass, overrides|
    klass.new(:report => new_report, :bill => new_bill)
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
      :congress => Congress.find_or_create_by_meeting(111),
      :subject => new_bill,
      :opencongress_id => Forgery(:basic).text
    )
  end

  define_builder(RepresentativeTerm) do |klass, overrides|
    klass.new(
      :politician => new_politician
    )
  end

  define_builder(SenateTerm) do |klass, overrides|
    klass.new(
      :politician => new_politician
    )
  end
end
