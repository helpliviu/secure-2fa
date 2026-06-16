class TemplatesController < ApplicationController
  before_action :authenticate_client!
  before_action :set_template, only: %i[show edit update destroy]

  def index
    @templates = current_client.templates.all.page(params[:page])
  end

  def show; end

  def new
    @template = current_client.templates.new
    @template.template_versions.build
  end

  def edit; end

  def create
    @template = current_client.templates.new(template_params)

    if @template.save
      redirect_to @template, notice: "Template created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @template.update(template_params)
      redirect_to @template, notice: "Template updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @template.destroy
      redirect_to templates_path, notice: "Template deleted."
    else
      redirect_to @template, alert: @template.errors.full_messages.to_sentence
    end
  end

  private

  def set_template
    @template = current_client.templates.find(params[:id])
  end

  def template_params
    params.require(:template).permit(
      :title, :markup,
      template_versions_attributes: [:id, :subject, :body, :lang, :_destroy]
    )
  end
end
