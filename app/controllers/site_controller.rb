class SiteController < ApplicationController

  def index
    if current_user
      dashboard
    else
      params[:in_office] = true

      @politicians =
        if shown_location
          sought_politicians
        else
          Politician.in_office
        end.scoped(:limit => 6)
      @sample_report = Report.with_scores_for(@politicians).published.random.first
      @scores = @sample_report.scores.for_politicians(@politicians)

      respond_to do |format|
        format.html {
          @recent_reports = Report.user_published.by_created_at.all(:limit => 3)
        }
        format.js {
          render :partial => 'reports/report_and_scores', :locals => {
            :report => @sample_report,
            :scores => @scores
          }
        }
      end
    end
  end

  def about
  end

  def dashboard
    @user = current_user
    @reports = current_user.reports
    render :template => 'users/show'
  end

  if Rails.env.development?
    def fake_location
      session[:geo_location] = session[:declared_geo_location] = Geokit::GeoLoc.new(:lat => 35, :lng => -90, :city => '- fake -', :state => 'TN', :zip => 88888, :country_code => 'US')
      session[:congressional_district] = District.lookup(session[:geo_location]).map(&:congressional_district).compact.first
      flash[:success] = 'Location set'
      redirect_to root_path
    end
  end
end
