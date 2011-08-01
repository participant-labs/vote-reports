module GuideQuestionsHelper
  def guide_question(question)
    BlueCloth::new("What's your view on [#{question.object.name.downcase}](#{polymorphic_path(question.object)})?").to_html.html_safe
  end
end
