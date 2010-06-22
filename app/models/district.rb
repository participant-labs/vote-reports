class District < ActiveRecord::Base
  composed_of :level, :mapping => %w(level level), :class_name => 'District::Level'

  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id

  named_scope :lookup, lambda {|geoloc|
    {:conditions => ["ST_Contains(the_geom, GeometryFromText('POINT(? ?)', -1))",
      geoloc.lng, geoloc.lat]}
  }
  named_scope :level, lambda {|level|
    if level.present?
      {:conditions => {:level => level}}
    else
      {}
    end
  }

  District::Level.levels.each do |level|
    named_scope level, :conditions => {:level => level}
    define_method :"#{level}?" do
      self.level.to_s == level
    end
  end

  delegate :envelope, :to => :the_geom
  def polygon
    @polygon ||= the_geom[0]
  end
  def linear_ring
    @linear_ring ||= the_geom[0][0]
  end

  def display_name
    if /^\d*$/ =~ name
      "#{state.abbreviation} #{name.to_i.ordinalize}"
    else
      "#{state.abbreviation} #{name}"
    end
  end

  def full_name
    "#{display_name} #{level.description}"
  end

  def congressional_district
    if federal?
      state.congressional_districts.find_by_district(name)
    end
  end
end
