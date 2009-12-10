require "friendly_id/sluggable/slug"
require "friendly_id/sluggable/class_methods"
require "friendly_id/sluggable/instance_methods"
require "friendly_id/non_sluggable/class_methods"
require "friendly_id/non_sluggable/instance_methods"

# FriendlyId is a comprehensive Ruby library for slugging and permalinks with
# ActiveRecord.
module FriendlyId

  # Default options for has_friendly_id.
  DEFAULT_OPTIONS = {
    :max_length       => 255,
    :reserved         => ["new", "index"],
    :validation_message => 'can not be "%s"'
  }.freeze

  # The names of all valid configuration options.
  VALID_OPTIONS = (DEFAULT_OPTIONS.keys + [
    :cache_column,
    :scope,
    :strip_diacritics,
    :strip_non_ascii,
    :use_slug
  ]).freeze

  # Set up an ActiveRecord model to use a friendly_id.
  #
  # The column argument can be one of your model's columns, or a method
  # you use to generate the slug.
  #
  # Options:
  # * <tt>:use_slug</tt> - Defaults to nil. Use slugs when you want to use a non-unique text field for friendly ids.
  # * <tt>:max_length</tt> - Defaults to 255. The maximum allowed length for a slug.
  # * <tt>:cache_column</tt> - Defaults to nil. Use this column as a cache for generating to_param (experimental) Note that if you use this option, any calls to +attr_accessible+ must be made BEFORE any calls to has_friendly_id in your class.
  # * <tt>:strip_diacritics</tt> - Defaults to nil. If true, it will remove accents, umlauts, etc. from western characters.
  # * <tt>:strip_non_ascii</tt> - Defaults to nil. If true, it will remove all non-ASCII characters.
  # * <tt>:reserved</tt> - Array of words that are reserved and can't be used as friendly_id's. For sluggable models, if such a word is used, the object and slug will fail validation. Defaults to ["new", "index"].
  # * <tt>:validation_message</tt> - The message that will be shown when a blank or reserved word is used as a frindly_id. Defaults to '"%s" is reserved'.
  #
  # You can also optionally pass a block if you want to use your own custom
  # slug normalization routines rather than the default ones that come with
  # friendly_id:
  #
  #   require "stringex"
  #   class Post < ActiveRecord::Base
  #     has_friendly_id :title, :use_slug => true do |text|
  #       # Use stringex to generate the friendly_id rather than the baked-in methods
  #       text.to_url
  #     end
  #   end
  def has_friendly_id(method, options = {}, &block)
    options.assert_valid_keys VALID_OPTIONS
    options = DEFAULT_OPTIONS.merge(options).merge(:method => method)
    write_inheritable_attribute :friendly_id_options, options
    class_inheritable_accessor :friendly_id_options
    if friendly_id_options[:use_slug]
      class_inheritable_reader :slug_normalizer_block
      write_inheritable_attribute(:slug_normalizer_block, (block_given? && block) || lambda do |slug|
        slug = Slug::strip_diacritics(slug) if self.friendly_id_options[:strip_diacritics]
        slug = Slug::strip_non_ascii(slug) if self.friendly_id_options[:strip_non_ascii]
        Slug::normalize(slug)
      end)
      extend Sluggable::ClassMethods
      include Sluggable::InstanceMethods
    else
      extend NonSluggable::ClassMethods
      include NonSluggable::InstanceMethods
    end
  end
end

class ActiveRecord::Base #:nodoc:#
  extend FriendlyId #:nodoc:#
end
