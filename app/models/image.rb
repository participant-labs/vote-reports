class Image < PaperclipAutosizer
  has_attached_file :thumbnail,
        styles: {
          large: ["200x200", :png],
          header:  ["120x120", :png],
          normal: ["100x100", :png],
          tiny: ['35x35', :png]
        },
        processors: [:autosize, :jcropper],
        default_style: :normal

  after_post_process :autosize_attached_files

  validates_attachment_presence :thumbnail
  validates_attachment_content_type :thumbnail, content_type: ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png', 'image/gif', 'image/x-png']

  delegate :url, to: :thumbnail

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_update :reprocess_thumbnail, if: :cropping?

  class << self
    def laws_i_like
      first(conditions: {thumbnail_file_name: 'lawsilike.png'})
    end
  end

  def cropping?
    [crop_x, crop_y, crop_w, crop_h].all?(&:present?)
  end

  def exists?
    thumbnail.file?
  end

  # helper method used by the cropper view to get the real image geometry
  def thumbnail_geometry(style = :original)
    @geometry ||= {}
    path = thumbnail.path(style)
    if path.present?
      @geometry[style] ||= Paperclip::Geometry.from_file path
    else
      @default_geometry ||= Paperclip::Geometry.from_file Rails.root.join("public/thumbnails/#{style}/missing.png")
    end
  end

  private

  def reprocess_thumbnail
    thumbnail.reprocess!
  end
end
