module LanguageHelper
  def possesive(string)
    string <<
      if strip_links(string).ends_with?('s')
        "'"
      else
        "'s"
      end.html_safe
  end
end
