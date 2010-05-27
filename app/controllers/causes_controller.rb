class CausesController < ApplicationController
  filter_resource_access

  def index
    @causes = Cause.paginate :page => params[:page]

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
  end

  def show
  end

  def edit
  end

  def update
  end
end
