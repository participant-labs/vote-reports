class CausesController < ApplicationController
  filter_resource_access

  def index
    @causes = Cause.paginate :page => params[:page], :order => :name

    respond_to do |format|
      format.html
      format.js {
        render 'cases/list', :causes => @causes
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
      render :action => :new
    end
  end

  def show
    if !@cause.friendly_id_status.best?
      redirect_to cause_path(@cause), :status => 301
      return
    end
  end

  def edit
    if !@cause.friendly_id_status.best?
      redirect_to edit_cause_path(@cause), :status => 301
      return
    end
  end

  def update
    @cause = Cause.find(params[:id])
    if @cause.update_attributes(params[:cause])
      flash[:notice] = "Successfully updated Cause"
      redirect_to @cause
    else
      flash[:error] = "Unable to update Cause"
      render :action => :edit
    end
  end
end
