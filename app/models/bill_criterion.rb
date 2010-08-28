class BillCriterion < ActiveRecord::Base
  include Criterion

  belongs_to :bill
  alias_method :subject, :bill

  validates_presence_of :bill, :report
  validates_uniqueness_of :bill_id, :scope => "report_id"

  accepts_nested_attributes_for :bill

  named_scope :by_introduced_on, :select => 'DISTINCT(bill_criteria.*), bills.introduced_on', :joins => :bill, :order => 'bills.introduced_on DESC'

  named_scope :active, :select => 'DISTINCT bill_criteria.*',
    :joins => {:bill => :rolls},
    :conditions => Roll.on_bill_passage.proxy_options[:conditions]

  class << self
    def inactive
      all - active
    end

    def autofetch_from(url)
      html = Nokogiri::HTML(open(url))
      stances = {}
      if html.css("img[src='http://images.capwiz.com/img/issues_images/stracktext_support.gif']").present? \
        || html.css("img[src='http://images.capwiz.com/img/issues_images/stracktext_oppose.gif']").present?
        html.css("img[src='http://images.capwiz.com/img/issues_images/stracktext_support.gif']").each do |supported|
          supported = supported.parent.parent.parent.css('td[align=left]')
          stances[supported.inner_text] = {:explanatory_url => "http://capwiz.com#{supported.css('a[href]').attr('href')}", :support => true}
        end
        html.css("img[src='http://images.capwiz.com/img/issues_images/stracktext_oppose.gif']").each do |opposed|
          opposed = opposed.parent.parent.parent.css('td[align=left]')
          stances[opposed.inner_text] = {:explanatory_url => "http://capwiz.com#{opposed.css('a[href]').attr('href')}", :support => false}
        end
      else
        html.css("tr > td > span.casmallnormal > a[href]").each do |supported|
          supported = supported.parent.parent
          stances[supported.inner_text] = {:explanatory_url => "http://capwiz.com#{supported.css('a[href]').attr('href')}", :support => true}
        end
      end
      stances
    end
  end

  def unvoted?
    bill.passage_rolls.empty?
  end

  def events
    bill.passage_rolls.all(:include => {:votes => [{:politician => :state}, :roll]}).map(&:votes).flatten
  end

  def event_score(vote)
    if aligns?(vote)
      100.0
    elsif contradicts?(vote)
      0.0
    else
      50.0
    end
  end

end
