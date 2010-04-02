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

  def human_type_name(type)
    type.underscore.humanize.downcase
  end

  def page_title
    raise "Missing page title" if @page_title.blank?
    ['VoteReports', @page_title].compact.join(' :: ')
  end

  def title(page_title)
    @page_title = page_title.to_s
  end

  def format_newlines(text)
    text.to_s.gsub(/(?:\n\r?|\r\n?)/, '<br />')
  end
  safe_helper :format_newlines

  def to_html(text)
    text.to_s.split("\n").map {|paragraph|
      content_tag :p, paragraph
    }.join
  end
  safe_helper :to_html

  def flash_helper
    flash.map do |(level, message)|
      content_tag(:div, message, :class => [level, " flash"]) if message.present?
    end
  end
  safe_helper :flash_helper

  def tag_cloud(tags, classes)
    return [] if tags.empty?

    if tags.first.respond_to?(:count)
      min = tags.last.count.to_f
      spread = tags.first.count.to_f - min
      spread = 1 if spread == 0
      max_index = classes.size - 1

      tags.sort_by(&:name).each do |tag|
        index = (((tag.count.to_f - min) / spread) * max_index).round
        raise "Bad index #{index} from #{tag.count}, #{tags.first.count}, #{tags.last.count}" if index > max_index
        yield tag, classes[index]
      end
    else
      tags.sort_by(&:name).each do |tag|
        yield tag, classes.first
      end
    end
  end

end
