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

    min = tags.last.count.to_f
    spread = tags.first.count.to_f - min
    max_index = classes.size - 1

    tags.sort_by(&:name).each do |tag|
      index = (((tag.count.to_f - min) / spread) * max_index).round
      raise "Bad index #{index} from #{tag.count}, #{tags.first.count}, #{tags.last.count}" if index > max_index
      yield tag, classes[index]
    end
  end

end
