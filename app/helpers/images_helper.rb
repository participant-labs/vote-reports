module ImagesHelper
  def hover_image_tag(image, title, style = image.thumbnail.default_style)
    attachment = image.thumbnail
    attrs =
      if attachment.file? && style != :large
        {:'data-qtip-image' => attachment.url(:large)}
      end
    image_tag(attachment.url(style), (attrs || {}).merge(
      :alt => title, :title => title
    ))
  end
end