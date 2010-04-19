# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include LocationsHelper

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  geocode_ip_address

  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation

  def permission_denied
    if current_user
      flash[:error] = 'Sorry, you are not allowed to the requested page.'
      notify_exceptional("User #{current_user.inspect} attempted to access protected page #{request.path}")
      respond_to do |format|
        format.html { redirect_to(:back) rescue redirect_to('/') }
        format.xml  { head :unauthorized }
        format.js   { head :unauthorized }
      end
    else
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path(:return_to => request.path)
    end
  end

  private

  def login_required
    unless current_user
      #store_location #TODO: implement store location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path(:return_to => request.path)
      return false
    end
  end

  def is_report_owner
    return if login_required == false
    report_owner = User.find(params[:user_id])
    unless current_user.admin? || (current_user == report_owner)
      notify_exceptional("User #{current_user.inspect} attempted to access protected page #{request.path}")
      flash[:notice] = "You may not access this page"
      redirect_to user_report_path(report_owner, report_owner.reports.find(params[:report_id] || params[:id], :scope => report_owner))
      return false
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
