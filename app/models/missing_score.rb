class MissingScore < Struct.new(:politician)
  def initialize(args)
    @politician = args[:politician]
    @report = args[:report]
  end

  attr_reader :politician, :report
end