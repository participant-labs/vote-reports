class AddSunlightAttributesToPolitician < ActiveRecord::Migration
  def self.up
    add_column :politicians, :bioguide_id, :string
    add_column :politicians, :congress_office, :string
    add_column :politicians, :congresspedia_url, :string
    add_column :politicians, :crp_id, :string
    add_column :politicians, :district, :string
    add_column :politicians, :email, :string
    add_column :politicians, :event_id, :string
    add_column :politicians, :fax, :string
    add_column :politicians, :fec_id, :string
    add_column :politicians, :gender, :string
    add_column :politicians, :in_office, :string
    add_column :politicians, :middlename, :string
    add_column :politicians, :name_suffix, :string
    add_column :politicians, :nickname, :string
    add_column :politicians, :party, :string
    add_column :politicians, :phone, :string
    add_column :politicians, :senate_class, :string
    add_column :politicians, :state, :string
    add_column :politicians, :title, :string
    add_column :politicians, :twitter_id, :string
    add_column :politicians, :webform, :string
    add_column :politicians, :website, :string
    add_column :politicians, :youtube_url, :string
  end

  def self.down
    remove_column :politicians, :bioguide_id
    remove_column :politicians, :congress_office
    remove_column :politicians, :congresspedia_url
    remove_column :politicians, :crp_id
    remove_column :politicians, :district
    remove_column :politicians, :email
    remove_column :politicians, :event_id
    remove_column :politicians, :fax
    remove_column :politicians, :fec_id
    remove_column :politicians, :gender
    remove_column :politicians, :in_office
    remove_column :politicians, :middlename
    remove_column :politicians, :name_suffix
    remove_column :politicians, :nickname
    remove_column :politicians, :party
    remove_column :politicians, :phone
    remove_column :politicians, :senate_class
    remove_column :politicians, :state
    remove_column :politicians, :title
    remove_column :politicians, :twitter_id
    remove_column :politicians, :webform
    remove_column :politicians, :website
    remove_column :politicians, :youtube_url
  end
end
