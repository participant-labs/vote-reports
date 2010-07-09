module ImagesHelper
  def hover_image_attrs(image)
    attachment = image.thumbnail
    if attachment.file?
      {
        :class => "act-qtip-image qtip-width-#{attachment.styles[:large][:geometry].split('x').first.to_i}",
        :rel => attachment.url(:large)
      }
    else
      {}
    end
  end

  def image_with_hover_tag(image, title, attrs = {})
    style = attrs.delete(:style) || image.thumbnail.default_style
    attrs.reverse_merge!(:alt => title, :title => title)
    attrs.merge!(hover_image_attrs(image)) if style != :large
    image_tag(image.thumbnail.url(style), attrs)
  end
end
