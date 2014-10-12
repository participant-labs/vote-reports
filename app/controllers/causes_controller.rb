class CausesController < ApplicationController
  filter_resource_access

  def index
    @causes = Cause.order(:name).page(params[:page])

    respond_to do |format|
      format.html
      format.js {
        render partial: 'causes/list', locals: {causes: @causes}
      }
      format.json {
        render json: Cause.all
      }
    end
  end

  def new
  end

  def create
    if @cause.save
      flash[:notice] = "Successfully created Cause"
      redirect_to @cause
    else
      flash[:error] = "Unable to create Cause"
      render action: :new
    end
  end

  def show
    @subjects = @cause.subjects.for_tag_cloud
      .select("DISTINCT(subjects.*), SUM(report_subjects.count) AS count").limit(3)

    @scores = @cause.scores.for_politicians(sought_politicians).by_score

    respond_to do |format|
      format.html {
        unless request.path.start_with?(cause_path(@cause))
          redirect_to cause_path(@cause), status: 301
          return
        end
        @related_causes = @cause.related_causes.limit(3)
      }
      format.js {
        render partial: 'reports/scores/table', locals: {
          report: @cause.report, scores: @scores, replace: 'scores', target_path: cause_path(@cause)
        }
      }
      format.json {
        cause_hash = @cause.as_json
        cause_hash["cause"].merge!(
          "subjects" => @subjects,
          "related_causes" => @cause.related_causes
        )
        render json: cause_hash
      }
    end
  end

  def edit
    if request.path != edit_cause_path(@cause)
      redirect_to edit_cause_path(@cause), status: 301
    end
  end

  def update
    if @cause.update_attributes(cause_params)
      flash[:notice] = "Successfully updated Cause"
      redirect_to @cause
    else
      flash[:error] = "Unable to update Cause"
      render action: :edit
    end
  end

  def destroy
    @cause.destroy
    redirect_to causes_path
  end

  private

  def new_cause_from_params
    @cause = Cause.new(cause_params)
  end

  def load_cause
    @cause = Cause.friendly.find(params[:id])
  end

  def cause_params
    params.require(:cause).permit(:name, :description)
  end
end
