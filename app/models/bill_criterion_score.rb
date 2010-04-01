class BillCriterionScore
  attr_reader :politician, :criterion, :events

  def initialize(args)
    @politician = args.fetch(:politician)
    @criterion = args.fetch(:bill_criterion)
    @events = args.fetch(:votes)
  end
end