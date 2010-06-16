class GuidesController < ApplicationController
  def new
    if params[:representing].present? && zip_code = ZipCode.zip_code(params[:representing])
      session[:zip_code] = zip_code
    end
    if params[:guide][:district_id].present?
      session[:district_id] = params[:guide][:district_id]
    end

    @guide = Guide.new(:zip_code => session[:zip_code], :district_id => session[:district_id])

    respond_to do |format|
      format.html {
        render :action => next_step
      }
      format.js {
        render :action => next_step, :layout => false
      }
    end

    # @dont_show_geo_address = true
    # 
    # if params[:representing].present? && zip_code?(params[:representing])
    #   session[:zip_code] = params[:representing]
    # end
    # 
    # params[:in_office] = true if params[:in_office].nil?
    # @politicians = sought_politicians.all(:limit => 5)
    # 
    # @causes = Cause.all(:order => 'name')
    #
    # respond_to do |format|
    #   format.html
    #   format.js {
    #     render :layout => false
    #   }
    # end
  end

  def create
    @guide = Guide.new(params[:guide].merge(:reports => Cause.find(params[:causes], :include => :report).map(&:report)))
    if @guide.save
      redirect_to guide_path(@guide)
    else
      render :action => next_step
    end
  end

  private

  def next_step
    if @guide.district.present?
      @causes = Cause.all
      :causes
    elsif @guide.zip_code.present?
      @districts = District.with_zip(@guide.full_zip)
      :district
    else
      :zip_code
    end
  end

end
