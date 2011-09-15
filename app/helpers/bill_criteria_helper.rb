module BillCriteriaHelper
  def support_or_oppose(criterion)
    side = (criterion.support? ? 'support' : 'oppose')
    if criterion.explanatory_url.present?
      link_to side.capitalize, criterion.explanatory_url, class: side
    else
      content_tag :span, side.capitalize, class: side
    end
  end

  def criterion_evidence(criterion)
    if criterion.explanatory_url.present?
      link_to 'Evidence', criterion.explanatory_url
    end
  end

  def criterion_status(criterion)
    if criterion.inactive?
      content_tag :span, criterion.subject.congress.current? ? "(no votes yet)" : "(no votes)", class: 'info', title: 'We have no record of roll call votes or sponsorships for this bill'
    end
  end
end
