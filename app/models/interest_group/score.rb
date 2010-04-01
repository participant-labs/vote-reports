class InterestGroup::Score
  attr_reader :politician_id, :criterion, :events

  def initialize(args)
    @politician_id = args.fetch(:politician_id)
    @criterion = args.fetch(:interest_group)
    @events = args.fetch(:ratings)
  end
end
