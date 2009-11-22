class Users::ReportsController < InheritedResources::Base
  actions :all
  belongs_to :user
  before_filter :login_required, :except => [:index, :show]
  defaults :route_prefix => ''

end
