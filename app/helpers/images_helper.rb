module ImagesHelper
  def hover_image_tag(image, title, style = image.thumbnail.default_style, options = {})
    attachment = image.thumbnail
    attrs =
      if attachment.file? && style != :large
        {
          :'data-qtip-image' => attachment.url(:large),
          :'data-qtip-width' => attachment.styles[:large][:geometry].split('x').first.to_i
        }
      end
    image_tag(attachment.url(style), (attrs || {}).merge(
      :alt => title, :title => title
    ).merge(options))
  end
end