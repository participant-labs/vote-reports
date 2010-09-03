class GuidesController < ApplicationController
  layout 'minimal'

  def new
    if params[:from] == 'location' && !session[:declared_geo_location]
      session[:geo_location_declared] = true
      @geoloc = session[:declared_geo_location] = session[:geo_location]
      load_location_show_support(@geoloc)
    end

    if params[:causes].present?
      session[:guide_causes] = params[:causes]
    end

    reports = session[:guide_causes].present? ? Cause.find(session[:guide_causes], :include => :report).map(&:report) : []

    @guide = Guide.new(:geoloc => current_geo_location, :reports => reports)

    respond_to do |format|
      format.html {
        render :action => next_step
      }
      format.js {
        @js = true
        render :action => next_step, :layout => false
      }
    end
  end

  def create
    @guide = Guide.new(params[:guide].merge(:reports => Cause.find(params[:causes], :include => :report).map(&:report)))
    if @guide.save
      redirect_to guide_path(@guide)
    else
      render :action => next_step
    end
  end

  def show
    @guide = Guide.find(params[:id])
    @scores = @guide.scores.for_politicians(sought_politicians)
    @report = @guide.report

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'reports/scores/table', :locals => {:report => @report, :scores => @scores}
      }
    end
  end

  private

  def next_step
    if params[:from] == 'causes'
      @under_consideration = @guide.next_question
      if params[:selected]
        @selected = Report.find(params[:selected])
        @scores = @selected.scores.for_politicians(sought_politicians)
      else
        @scores = @guide.immediate_scores
      end
      :cause_scores
    elsif params[:from] == 'location'
      @questions = @guide.questions
      @under_consideration = @guide.next_question
      @scores = @guide.immediate_scores
      :causes
    else
      load_location_show_support(current_geo_location) if current_geo_location
      :set_location
    end
  end

end
