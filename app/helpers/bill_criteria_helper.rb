module BillCriteriaHelper
  def support_or_oppose(criterion)
    side = (criterion.support? ? 'support' : 'oppose')
    if criterion.explanatory_url.present?
      link_to side.capitalize, criterion.explanatory_url, :class => side
    else
      content_tag :span, side.capitalize, :class => side
    end
  end
end
