class SiteController < ApplicationController
  
  def index
    @recent_reports = Report.all(:limit => 10, :order => 'updated_at')
  end
  
  def about
  end
  
end
