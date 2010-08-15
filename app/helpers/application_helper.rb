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

  def google_maps_url(address)
    "http://mapof.it/#{URI.escape(address.to_s)}"
  end

  def page_title
    raise "Missing page title" if @page_title.blank?
    [@page_title, 'VoteReports'].compact.join(' - ')
  end

  def title(page_title)
    @page_title = page_title.to_s
  end

  def pluralize_word(count, word)
    count == 0 || count > 1 ? word.pluralize : word
  end

  def errors_for(form, *fields)
    fields.map do |field|
      if field == :base
        Array(form.object.errors.on_base).uniq.map do |error|
          content_tag :p, error, :class => 'error'
        end
      else
        Array(form.object.errors.on(field)).uniq.map do |error|
          content_tag :p, error, :class => 'error'
        end
      end
    end.flatten.join.html_safe
  end

  def md_to_text(md)
    strip_tags(md_to_html(md)).gsub('&amp;', '&')
  end
  safe_helper :md_to_text

  def md_to_html(md)
    BlueCloth::new(md).to_html
  end
  safe_helper :md_to_html

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
