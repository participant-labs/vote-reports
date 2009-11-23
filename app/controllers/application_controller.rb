# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  helper_method :current_user

  before_filter :ensure_domain if Rails.env.production?

  def login_required
    unless current_user
      #store_location #TODO: implement store location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path(:return_to => request.path)
      return false
    end
  end

  def is_admin?
    unless current_user && current_user.admin?
      flash[:notice] = "You are not an admin"
      redirect_to login_path
      return false
    end
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  DOMAIN = 'http://www.votereports.org'

  def ensure_domain
    Rails.logger.error request.env['HTTP_HOST']
  end
end
