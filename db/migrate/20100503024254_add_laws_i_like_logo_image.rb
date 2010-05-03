class AddLawsILikeLogoImage < ActiveRecord::Migration
  def self.up
    Image.create!(:thumbnail => open(Rails.root.join('public/lawsilike.png')))
  end

  def self.down
  end
end
