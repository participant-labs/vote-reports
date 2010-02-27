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
    raise "Missing page title" if @page_title.blank?
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
    flash.map do |(level, message)|
      content_tag(:div, message, :class => [level, " flash"]) if message.present?
    end
  end
  safe_helper :flash_helper

  def tag_cloud(tags, classes)
    return [] if tags.empty?

    max = tags.first.count.to_i
    min = tags.last.count.to_i
    divisor = ((max - min) / classes.size) + 1

    tags.each do |tag|
      yield tag, classes[(tag.count.to_i - min) / divisor]
    end
  end

end
