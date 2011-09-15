module ImagesHelper
  def sized_image_tag(image, title, attrs = {})
    style = attrs.delete(:style) || image.thumbnail.default_style
    attrs.reverse_merge!(alt: title, title: title)
    attrs.reverse_merge!(size: image.send(:"thumbnail_#{style}_size")) if image.respond_to?(:"thumbnail_#{style}_size")
    image_tag(image.thumbnail.url(style), attrs)
  end
end
