class User::ReportsController < InheritedResources::Base
  actions :all
  belongs_to :user
  before_filter :login_required

end
