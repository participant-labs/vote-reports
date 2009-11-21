require File.dirname(__FILE__) + '/../spec_helper'
 
describe ReportsController do


  requires_login_for :get,    :index
  requires_login_for :post,   :create  
  requires_login_for :put,    :update  
  requires_login_for :get,    :edit
  requires_login_for :get,    :new
  requires_login_for :delete, :destroy
end
