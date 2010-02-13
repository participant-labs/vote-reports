class Report < ActiveRecord::Base
  module Thumbnail
    def included(base)
      base.class_eval do
        has_attached_file :thumbnail,
              :styles => { :normal => "240x240>",
                           :small = > "55x55#" },
              :processors => [:jcropper],
              :default_url => "/images/reports/default_thumbnail.jpg"

        validates_attachment_content_type :thumbnail, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png']

        attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

        after_update :reprocess_thumbnail, :if => :cropping?
      end
    end

    def cropping?
      !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
    end

    # helper method used by the cropper view to get the real image geometry
    def thumbnail_geometry(style = :original)
      @geometry ||= {}
      @geometry[style] ||= Paperclip::Geometry.from_file thumbnail.path(style)
    end

  private

    def reprocess_thumbnail
      thumbnail.reprocess!
    end
  end
end