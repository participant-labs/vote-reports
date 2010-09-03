class GuideQuestion
  def self.questions
    (Issue.all.map {|issue|
      {:question => "What's your view on #{issue.title.downcase}?", :object => issue, :options => issue.causes.inject({}) {|accum, cause| accum[cause] = cause.name; accum }}
    } + Cause.without_issue.map {|cause| 
      {:question => "What's your view on #{cause.name.downcase}?", :object => cause, :options => {cause => 'Support'}}
    }).map {|attrs|
      new(attrs)
    }
  end

  def initialize(attrs)
    @question = attrs[:question]
    @object = attrs[:object]
    @options = attrs[:options]
  end

  attr_accessor :options, :question, :object
end
