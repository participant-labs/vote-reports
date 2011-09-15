class GuideQuestion
  class << self
    include ActionView::Helpers::UrlHelper

    def all
      (Issue.all(include: :causes) + Cause.without_issue).map {|attrs|
        new(attrs)
      }
    end
  end

  def initialize(object)
    @object = object
    @options =
      if object.is_a?(Cause)
        ActiveSupport::OrderedHash[[
          ['Oppose', CausePosition.new(object, :oppose)],
          ['Support', CausePosition.new(object, :support)]
        ]]
      else
        Hash[object.causes.map {|cause|
          [cause.name, CausePosition.new(cause, :support)]
        }]
      end
  end

  attr_accessor :options, :object

  def answered_by?(reports)
    options.values.map {|position| position.cause.report }.any? {|r| reports.include?(r) }
  end
end
