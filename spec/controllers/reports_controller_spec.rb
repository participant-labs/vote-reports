require File.dirname(__FILE__) + '/../spec_helper'
 
describe ReportsController do
  setup :activate_authlogic

  requires_login_for :get,    :new

end
