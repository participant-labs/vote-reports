class District < ActiveRecord::Base
  composed_of :level, mapping: %w(level level), :class_name => 'District::Level'

  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
  has_one :congressional_district
  has_many :races
  has_many :offices, through: :races

  scope :random, order('random()')
  scope :lookup, lambda {|geoloc|
    if geoloc.success?
      where(["ST_Contains(the_geom, GeometryFromText('POINT(? ?)', -1))",
        geoloc.lng, geoloc.lat])
    else
      where('0 = 1')
    end
  }
  scope :level, lambda {|level|
    if level.present?
      where(level: level)
    else
      {}
    end
  }
  scope :state, lambda {|abbr|
    joins(:state).where('us_states.abbreviation' => abbr)
  }

  scope :with_name, lambda {|district_name|
    name = ((district_name =~ /^\d+$/) ? district_name.to_i.to_s.rjust(3, '0') : district_name)
    where(name: name)
  }

  validates_presence_of :congressional_district, if: :federal?

  District::Level.levels.each do |level|
    scope level, where(level: level)
    define_method :"#{level}?" do
      self.level.to_s == level
    end
  end

  delegate :envelope, to: :the_geom

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
