# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def participant_labs_path
    'http://participantlabs.com/'
  end

  def blog_path
    'http://blog.votereports.org/'
  end

  def get_satisfaction_path
    'http://getsatisfaction.com/votereports'
  end

  def page_title
    ['VoteReports', @page_title].compact.join(' :: ')
  end

  def title(page_title)
    @page_title = page_title.to_s
  end

  def to_html(text, html_attrs = {})
    content_tag :div, text.to_s.split("\n").map {|paragraph|
      content_tag :p, paragraph
    }.join, html_attrs
  end

  def flash_helper
    [:notice, :warning, :message].map { |f| content_tag(:div, flash[f], :class => [f, " flash"]) if flash[f] }
  end
  safe_helper :flash_helper

end
