class AddBoundingDataToUsStates < ActiveRecord::Migration
  def change
    add_column :us_states, :bounds, :string
    ActiveRecord::Base.transaction do
      UsState.find_each do |us_state|
        districts = us_state.districts
        next if districts.blank?
        firsts = districts.map {|district| district.bounding_box.first }
        first_x = firsts.map(&:x).min
        first_y = firsts.map(&:y).min
        lasts = districts.map {|district| district.bounding_box.last }
        last_x = lasts.map(&:x).max
        last_y = lasts.map(&:y).max
        us_state.update_attribute(:bounds, [first_x, last_y, last_x, first_y].join(','))
      end
    end
  end
end
