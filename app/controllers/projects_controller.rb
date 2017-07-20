class ProjectsController < ApplicationController
  def index
    @projects = ProjectDefinition.all
  end

  def show
    @project = ProjectDefinition.find(params[:id])
  end
end
