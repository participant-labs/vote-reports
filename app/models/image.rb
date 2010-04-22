class Image < ActiveRecord::Base
  DEFAULT_THUMBNAIL_PATH = "reports/default_thumbnail.jpg"

  has_attached_file :thumbnail,
        :styles => {
          :large =>  ["120x120", :png],
          :normal => ["100x100", :png]
        },
        :processors => [:jcropper],
        :default_style => :normal

  validates_attachment_presence :thumbnail
  validates_attachment_content_type :thumbnail, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png', 'image/gif', 'image/x-png']

  delegate :url, :to => :thumbnail

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_update :reprocess_thumbnail, :if => :cropping?

  def cropping?
    [crop_x, crop_y, crop_w, crop_h].all?(&:present?)
  end

  # helper method used by the cropper view to get the real image geometry
  def thumbnail_geometry(style = :original)
    @geometry ||= {}
    path = thumbnail.path(style)
    if path.present?
      @geometry[style] ||= Paperclip::Geometry.from_file path
    else
      @default_geometry ||= Paperclip::Geometry.from_file Rails.root.join('public/images', DEFAULT_THUMBNAIL_PATH)
    end
  end

  private

  def reprocess_thumbnail
    thumbnail.reprocess!
  end
end
