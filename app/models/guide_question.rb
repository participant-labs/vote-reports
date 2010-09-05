class GuideQuestion
  class << self
    def all
      (Issue.all(:include => :causes) + Cause.without_issue).map {|attrs|
        new(attrs)
      }
    end
  end

  def initialize(object)
    @question = "What's your view on #{object.name.downcase}?"
    @object = object
    @options =
      if object.is_a?(Cause)
        {object => 'Support'}
      else
        object.causes.inject({}) {|accum, cause| accum[cause] = cause.name; accum }
      end
  end

  attr_accessor :options, :question, :object

  def answered_by?(reports)
    options.keys.map(&:report).any? {|r| reports.include?(r) }
  end
end

