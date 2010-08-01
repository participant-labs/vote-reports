class DistrictsAreMeaninglessWithTheGeom < ActiveRecord::Migration
  def self.up
    change_column_null :districts, :the_geom, false
  end

  def self.down
    change_column_null :districts, :the_geom, true
  end
end
