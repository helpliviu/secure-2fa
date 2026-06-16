class ProjectsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = current_client.projects.all.page(params[:page])
  end

  def show; end

  def new
    @project = current_client.projects.new
    @project.build_channel
    @project.build_template
  end

  def edit; end

  def create
    @project = current_client.projects.new(project_params)

    if @project.save
      redirect_to @project, notice: "Project created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project deleted."
  end

  private

  def set_project
    @project = current_client.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :title, :channel_id, :template_id,
      :expiration_seconds, :max_attempts, :webhook_url,
      channel_attributes:          [:id, :title, :method, :provider, :credentials],
      template_attributes:         [:id, :title, :markup,
        template_versions_attributes: [:id, :subject, :body, :lang, :_destroy]]
    )
  end
end
