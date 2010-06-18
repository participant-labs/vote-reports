module ImagesHelper
  def hover_image_attrs(image)
    attachment = image.thumbnail
    if attachment.file?
      {
        :'data-qtip-image' => attachment.url(:large),
        :'data-qtip-width' => attachment.styles[:large][:geometry].split('x').first.to_i
      }
    else
      {}
    end
  end

  def image_with_hover_tag(image, title, attrs = {})
    style = attrs.delete(:style) || image.thumbnail.default_style
    attrs.reverse_merge!(:alt => title, :title => title)
    attrs.merge!(hover_image_attrs(image)) if style != :large
    attrs.merge!(:size => image.thumbnail.styles[style][:geometry])
    image_tag(image.thumbnail.url(style), attrs)
  end
end
