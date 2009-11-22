# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def page_title
    @page_title || 'Vote Reports'
  end

  def title(page_title)
    @page_title = page_title.to_s
  end
  
  def flash_helper
    [:notice, :warning, :message].map { |f| content_tag(:div, flash[f], :class => [f, " flash"]) if flash[f] }
  end

end
