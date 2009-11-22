module BillCriteriaHelper
  def support_or_oppose(criterion)
    if criterion.support?
      content_tag :span, 'Support', :class => 'support'
    else
      content_tag :span, 'Oppose', :class => 'oppose'
    end
  end
end
