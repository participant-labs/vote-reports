class District < ActiveRecord::Base
  composed_of :level, :mapping => %w(level level), :class_name => 'District::Level'

  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
  has_one :congressional_district

  named_scope :random, :order => 'random()'
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
  named_scope :state, lambda {|abbr|
    {:joins => :state, :conditions => {'us_states.abbreviation' => abbr}}
  }

  named_scope :with_name, lambda {|district_name|
    name = Integer(district_name).to_s.rjust(3, '0') rescue district_name
    {:conditions => {:name => name }}
  }

  validates_presence_of :congressional_district, :if => :federal?

  District::Level.levels.each do |level|
    named_scope level, :conditions => {:level => level}
    define_method :"#{level}?" do
      self.level.to_s == level
    end
  end

  delegate :envelope, :to => :the_geom

  class << self
    def geocode(loc)
      lookup(Geokit::Geocoders::MultiGeocoder.geocode(loc))
    end

    def ordinal_name(name)
      if name =~ /^\d+$/
        name.to_i.ordinalize
      else
        name
      end
    end
  end

  def level=(level)
    self[:level] = level
  end

  def to_param
    name
  end

  def ordinal_name
    District.ordinal_name(name)
  end

  def title
    if federal?
      congressional_district.title
    else
      position =
        case level.level
        when 'state_upper'
          'State Senate'
        when 'state_lower'
          'State Assembly'
        end
      "#{ordinal_name} #{position}  District"
    end
  end

  def full_name
    display_name =
      if federal?
        "#{state.abbreviation}-#{name}"
      elsif /^\d*$/ =~ name
        "#{state.abbreviation} #{name.to_i.ordinalize}"
      else
        "#{state.abbreviation} #{name}"
      end

    "#{display_name} #{level.description}"
  end
end
