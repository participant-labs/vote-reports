module FriendlyId
  module Sluggable
    module InstanceMethods

      def self.included(base)
        base.class_eval do
          has_many :slugs, :order => 'id DESC', :as => :sluggable, :dependent => :destroy, :validate => false
          validate :validate_latest_slug

          before_validation :create_slug
          before_save :set_slug_cache
          # only protect the column if the class is not already using attributes_accessible
          if !accessible_attributes
            if friendly_id_options[:cache_column]
              attr_protected friendly_id_options[:cache_column].to_sym
            end
            attr_protected :cached_slug
          end

          class << self
            extend ActiveSupport::Memoizable

            def cache_column
              friendly_id_options[:cache_column].try(:to_sym) ||
                (:cached_slug if columns.any? { |c| c.name == 'cached_slug' })
            end
            memoize :cache_column
          end
        end
      end

      attr_accessor :finder_slug_name

      def finder_slug
        @finder_slug ||= init_finder_slug or nil
      end

      # Was the record found using one of its friendly ids?
      def found_using_friendly_id?
        !!@finder_slug_name
      end

      # Was the record found using its numeric id?
      def found_using_numeric_id?
        !found_using_friendly_id?
      end

      # Was the record found using an old friendly id?
      def found_using_outdated_friendly_id?
        return false if cache_column && send(cache_column) == @finder_slug_name
        finder_slug.id != slug.id
      end

      # Was the record found using an old friendly id, or its numeric id?
      def has_better_id?
        has_a_slug? and found_using_numeric_id? || found_using_outdated_friendly_id?
      end

      # Does the record have (at least) one slug?
      def has_a_slug?
        @finder_slug_name || slug
      end

      # Returns the friendly id.
      def friendly_id
        slug(true).to_friendly_id
      end
      alias best_id friendly_id

      # Has the basis of our friendly id changed, requiring the generation of a
      # new slug?
      def new_slug_needed?
        !slug || slug_text != slug.name
      end

      # Returns the most recent slug, which is used to determine the friendly
      # id.
      def slug(reload = false)
        @most_recent_slug = nil if reload
        @most_recent_slug ||= slugs.first(:order => "id DESC")
      end

      # Returns the friendly id, or if none is available, the numeric id.
      def to_param
        if cache_column
          read_attribute(cache_column) || id.to_s
        else
          slug ? slug.to_friendly_id : id.to_s
        end
      end

      # Get the processed string used as the basis of the friendly id.
      def slug_text
        self.slug_normalizer_block.call(
          send(friendly_id_options[:method])
        ).mb_chars.to(friendly_id_options[:max_length] - 1)
      end

    private

      def validate_latest_slug
        unless slugs.last.valid?
          errors.add(friendly_id_options[:method], friendly_id_options[:validation_message] % send(friendly_id_options[:method]))
        end
      end

      def cache_column
        self.class.cache_column
      end

      def finder_slug=(finder_slug)
        @finder_slug_name = finder_slug.name
        finder_slug.tap do |slug|
          slug.sluggable = self
        end
      end

      def init_finder_slug
        return false if !@finder_slug_name
        name, sequence = Slug.parse(@finder_slug_name)
        slug = Slug.find(:first, :conditions => {:sluggable_id => id, :name => name, :sequence => sequence, :sluggable_type => self.class.base_class.name })
        finder_slug = slug
      end

      # Set the slug using the generated friendly id.
      def create_slug
        if new_slug_needed?
          @most_recent_slug = nil
          slug_attributes = {:name => slug_text, :sluggable => self}
          slug_attributes[:scope] =
            if friendly_id_options[:scope]
              scope = send(friendly_id_options[:scope])
              scope.respond_to?(:to_param) ? scope.to_param : scope.to_s
            end
          # If we're renaming back to a previously used friendly_id, delete the
          # slug so that we can recycle the name without having to use a sequence.
          slugs.find(:all, :conditions => {:name => slug_text, :scope => slug_attributes[:scope]}).each { |s| s.destroy }
          @most_recent_slug = slugs.build(slug_attributes)
        end
      end

      def set_slug_cache
        if cache_column
          current_friendly_id = slug.to_friendly_id
          send("#{cache_column}=", current_friendly_id) if send(cache_column) != current_friendly_id
        end
      end

    end
  end
end
