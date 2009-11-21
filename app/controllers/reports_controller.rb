class ReportsController < InheritedResources::Base
  actions :all
  belongs_to :user, :optional => true
  before_filter :login_required, :except => [:index, :show]
  


end
