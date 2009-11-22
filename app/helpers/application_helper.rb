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
  
  def sidebar_link(text,path)
    current_page?(path) ? content_tag(:li, text, :class => "selected") : content_tag(:li, link_to(text,path))
  end

end
