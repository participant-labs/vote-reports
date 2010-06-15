class GuidesController < ApplicationController
  def new
    @dont_show_geo_address = true

    if params[:representing].present? && zip_code?(params[:representing])
      session[:zip_code] = params[:representing]
    end

    params[:in_office] = true if params[:in_office].nil?
    @politicians = sought_politicians.all(:limit => 5)

    @causes = Cause.all(:order => 'name')

    respond_to do |format|
      format.html
      format.js {
        render :layout => false
      }
    end
  end
end
