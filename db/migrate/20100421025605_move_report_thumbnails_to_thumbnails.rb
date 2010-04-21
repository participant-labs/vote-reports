class MoveReportThumbnailsToThumbnails < ActiveRecord::Migration
  class Report < ActiveRecord::Base
    has_attached_file :thumbnail,
      :styles => { :normal => "330x248>",
                   :thumbnail => '110x83#',
                   :small => "55x41#" }
  end

  class Thumbnail < ActiveRecord::Base
    has_attached_file :thumbnail,
      :styles => { :normal => "330x248>",
                   :thumbnail => '110x83#',
                   :small => "55x41#" }
  end

  def self.up
    add_column :reports, :thumbnail_id, :integer
    Report.all(:conditions => 'thumbnail_file_name IS NOT NULL').each do |report|
      thumbnail = Thumbnail.create!(:thumbnail => report.thumbnail)
      report.update_attribute(:thumbnail_id, thumbnail.id)
    end
    remove_columns :reports, :thumbnail_file_name, :thumbnail_content_type, :thumbnail_file_size
    constrain :reports, :thumbnail_id, :reference => {:thumbnails => :id}
  end

  def self.down
    raise "Nope"
  end
end
