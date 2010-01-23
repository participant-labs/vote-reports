module BillCriteriaHelper
  def support_or_oppose(criterion)
    side = (criterion.support? ? 'support' : 'oppose')
    if criterion.explanatory_url.present?
      link_to side.capitalize, criterion.explanatory_url, :class => side
    else
      content_tag :span, side.capitalize, :class => side
    end
  end

  def bill_criterion_status(criterion)
    if criterion.unvoted?
      content_tag :span, criterion.bill.congress.current? ? "(no votes yet)" : "(no votes)", :class => 'info', :title => 'We have no record of roll call votes for this bill'
    end
  end
end
