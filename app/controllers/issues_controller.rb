class IssuesController < ApplicationController
  def index
  end

  def new
    @issue = Issue.new
    @causes = Cause.all
  end
end
