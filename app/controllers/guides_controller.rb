class GuidesController < ApplicationController
  layout 'footer_and_header'

  def new
    if params[:from] == 'location' && !session[:declared_geo_location]
      session[:geo_location_declared] = true
      @geoloc = session[:declared_geo_location] = session[:geo_location]
      load_location_show_support(@geoloc)
    end

    session[:guide_causes] ||= []
    session[:guide_causes_opposed] ||= []

    if params[:support]
      session[:guide_causes] << params[:support]
    elsif params[:oppose]
      session[:guide_causes_opposed] << params[:oppose]
    elsif params[:remove]
      session[:guide_causes] -= params[:remove]
      session[:guide_causes_opposed] -= params[:remove]
    end

    supported = fetch_reports_for(session[:guide_causes])
    opposed = fetch_reports_for(session[:guide_causes_opposed])

    @guide = Guide.new(:geoloc => current_geo_location, :reports_supported => supported, :reports_opposed => opposed)

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

  def fetch_reports_for(slugs)
    slugs.present? ? Cause.find_all_by_cached_slug(slugs, :include => :report).map(&:report) : []
  end

  def next_step
    if params[:from] == 'causes'
      @under_consideration = @guide.unanswered_question
      if params[:selected]
        @selected = Report.find(params[:selected])
        @scores = @selected.scores.for_politicians(sought_politicians)
      else
        @scores = @guide.immediate_scores
      end
      :cause_scores
    elsif params[:from] == 'location'
      @questions = @guide.questions
      @under_consideration = @guide.unanswered_question
      @scores = @guide.immediate_scores
      :causes
    else
      load_location_show_support(current_geo_location) if current_geo_location
      :set_location
    end
  end

end
