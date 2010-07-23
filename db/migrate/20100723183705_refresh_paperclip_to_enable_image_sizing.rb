class RefreshPaperclipToEnableImageSizing < ActiveRecord::Migration
  def self.up
    ENV['CLASS'] = 'Image'
    Rake::Task['paperclip:refresh'].invoke
  end

  def self.down
  end
end
