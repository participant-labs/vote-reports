class AddASlugForEverySubject < ActiveRecord::Migration
  def self.up
    add_column :subjects, :cached_slug, :string
    ENV['MODEL'] = 'Subject'
    Sunspot.batch do
      Rake::Task['friendly_id:make_slugs'].invoke
    end
    change_column :subjects, :cached_slug, :string, :null => false
  end

  def self.down
    remove_column :subjects, :cached_slug
  end
end
